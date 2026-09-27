# Viste Diferente - Tienda Web Oficial

Catálogo web de playeras streetwear oversize en Flutter Web con arquitectura modular, carrito de compras multi-producto, vista detallada de prendas, navegación separada (Inicio / Catálogo) y pedidos directos a WhatsApp.

## Nuevas Características Implementadas
1. **Carrito de Compras Completo**:
   - Agregar playeras seleccionando modelo, talla y cantidad.
   - Contador dinámico flotante y en la cabecera.
   - Modal del carrito para ver el desglose, sumar/restar cantidades, eliminar prendas y ver el Total en MXN.
   - Botón para enviar el pedido consolidado a WhatsApp con todos los artículos.
2. **Navegación Separada (Catálogo en Ventana Propia)**:
   - Ruta `/` (Inicio): Presentación de la marca, propuesta de valor (240g, oversize, serigrafía), sección ¿Cómo pedir?, y botón de acceso al catálogo.
   - Ruta `/catalog` (Catálogo): Pantalla dedicada exclusivamente a explorar los modelos con filtros de categoría.
3. **Vista Detallada de Prenda (`ProductDetailDialog`)**:
   - Visualización en gran tamaño.
   - Especificaciones técnicas: 100% Algodón Peinado 240 GSM, corte Drop Shoulder, serigrafía tacto cero.
   - Tabla de medidas de referencia (CH, M, G, XG).
   - Selector interactivo de tallas y cantidad con agregado inmediato al carrito.
4. **Panel de Administración Oculto al Público**:
   - Se removió cualquier botón o icono de "Admin" en la interfaz de clientes.
   - Acceso privado y seguro exclusivamente mediante la ruta URL `/admin`.
5. **Identidad Visual y Logo**:
   - Integración completa de `assets/images/logo.jpeg` en Header, Hero y Footer.
   - Generación de Favicon y Web Icons (`web/favicon.png`, `web/icons/`).

## Ejecución Local
```bash
flutter pub get
flutter run -d chrome
```

## Despliegue en Firebase Hosting
```bash
flutter build web --release
firebase deploy --only hosting
```
