import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class ConfigService {
  static final ConfigService instance = ConfigService._internal();
  factory ConfigService() => instance;

  ConfigService._internal() {
    _loadInitialNumber();
  }

  // Colección 'settings' y documento 'store' (alineado con tus reglas de Firestore)
  final DocumentReference _configRef =
  FirebaseFirestore.instance.collection('settings').doc('store');

  /// Inicializa la sincronización en tiempo real desde Firebase
  void init() {
    _loadInitialNumber();
    try {
      getWhatsAppNumberStream().listen(
            (number) {
          debugPrint("✓ WhatsApp sincronizado desde Firebase: $number");
        },
        onError: (e) {
          debugPrint("Aviso stream WhatsApp: $e");
        },
      );
    } catch (e) {
      debugPrint("Error al suscribir stream WhatsApp: $e");
    }
  }

  void _loadInitialNumber() {
    try {
      if (kIsWeb) {
        final saved = html.window.localStorage['store_whatsapp_number'];
        if (saved != null && saved.isNotEmpty) {
          AppConstants.whatsappNumber = saved;
        }
      }
    } catch (_) {}
  }

  Stream<String> getWhatsAppNumberStream() {
    return _configRef.snapshots().map((doc) {
      try {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>?;
          final num = data?['whatsappNumber']?.toString();
          if (num != null && num.isNotEmpty) {
            AppConstants.whatsappNumber = num;
            if (kIsWeb) {
              try {
                html.window.localStorage['store_whatsapp_number'] = num;
              } catch (_) {}
            }
            return num;
          }
        }
      } catch (_) {}
      return AppConstants.whatsappNumber;
    }).handleError((_) => AppConstants.whatsappNumber);
  }

  Future<String> getWhatsAppNumber() async {
    try {
      final doc = await _configRef.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        final num = data?['whatsappNumber']?.toString();
        if (num != null && num.isNotEmpty) {
          AppConstants.whatsappNumber = num;
          if (kIsWeb) {
            try {
              html.window.localStorage['store_whatsapp_number'] = num;
            } catch (_) {}
          }
          return num;
        }
      }
    } catch (e) {
      debugPrint("Error al consultar Firestore settings: $e");
    }

    // Fallback local por si no hay conexión
    try {
      if (kIsWeb) {
        final local = html.window.localStorage['store_whatsapp_number'];
        if (local != null && local.isNotEmpty) {
          AppConstants.whatsappNumber = local;
          return local;
        }
      }
    } catch (_) {}

    return AppConstants.whatsappNumber;
  }

  Future<void> updateWhatsAppNumber(String newNumber) async {
    final cleaned = newNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return;

    // 1. Memoria de la app
    AppConstants.whatsappNumber = cleaned;

    // 2. Respaldo local en el navegador
    try {
      if (kIsWeb) {
        html.window.localStorage['store_whatsapp_number'] = cleaned;
      }
    } catch (e) {
      debugPrint("Aviso localStorage: $e");
    }

    // 3. Persistencia en Firestore (colección settings / documento store)
    try {
      await _configRef.set({
        'whatsappNumber': cleaned,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Aviso guardado Firestore settings: $e");
    }
  }
}