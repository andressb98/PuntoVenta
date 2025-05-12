/*
  Warnings:

  - You are about to drop the column `createdAt` on the `bitacora` table. All the data in the column will be lost.
  - You are about to drop the column `detalles` on the `bitacora` table. All the data in the column will be lost.
  - You are about to drop the column `ip` on the `bitacora` table. All the data in the column will be lost.
  - You are about to drop the column `registroId` on the `bitacora` table. All the data in the column will be lost.
  - You are about to drop the column `tabla` on the `bitacora` table. All the data in the column will be lost.
  - You are about to drop the column `usuarioId` on the `bitacora` table. All the data in the column will be lost.
  - You are about to drop the `_productoalmacen` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_productoproveedor` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `almacen` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `cliente` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `detalleventa` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `movimientoinventario` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `producto` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `proveedor` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `usuario` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `venta` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `descripcion` to the `bitacora` table without a default value. This is not possible if the table is not empty.
  - Added the required column `fecha_hora` to the `bitacora` table without a default value. This is not possible if the table is not empty.
  - Added the required column `id_registro_afectado` to the `bitacora` table without a default value. This is not possible if the table is not empty.
  - Added the required column `id_sucursal` to the `bitacora` table without a default value. This is not possible if the table is not empty.
  - Added the required column `id_usuario` to the `bitacora` table without a default value. This is not possible if the table is not empty.
  - Added the required column `tabla_afectada` to the `bitacora` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE `_productoalmacen` DROP FOREIGN KEY `_ProductoAlmacen_A_fkey`;

-- DropForeignKey
ALTER TABLE `_productoalmacen` DROP FOREIGN KEY `_ProductoAlmacen_B_fkey`;

-- DropForeignKey
ALTER TABLE `_productoproveedor` DROP FOREIGN KEY `_ProductoProveedor_A_fkey`;

-- DropForeignKey
ALTER TABLE `_productoproveedor` DROP FOREIGN KEY `_ProductoProveedor_B_fkey`;

-- DropForeignKey
ALTER TABLE `almacen` DROP FOREIGN KEY `Almacen_responsableId_fkey`;

-- DropForeignKey
ALTER TABLE `bitacora` DROP FOREIGN KEY `Bitacora_usuarioId_fkey`;

-- DropForeignKey
ALTER TABLE `detalleventa` DROP FOREIGN KEY `DetalleVenta_productoId_fkey`;

-- DropForeignKey
ALTER TABLE `detalleventa` DROP FOREIGN KEY `DetalleVenta_ventaId_fkey`;

-- DropForeignKey
ALTER TABLE `movimientoinventario` DROP FOREIGN KEY `MovimientoInventario_almacenId_fkey`;

-- DropForeignKey
ALTER TABLE `movimientoinventario` DROP FOREIGN KEY `MovimientoInventario_productoId_fkey`;

-- DropForeignKey
ALTER TABLE `movimientoinventario` DROP FOREIGN KEY `MovimientoInventario_proveedorId_fkey`;

-- DropForeignKey
ALTER TABLE `movimientoinventario` DROP FOREIGN KEY `MovimientoInventario_usuarioId_fkey`;

-- DropForeignKey
ALTER TABLE `movimientoinventario` DROP FOREIGN KEY `MovimientoInventario_ventaId_fkey`;

-- DropForeignKey
ALTER TABLE `venta` DROP FOREIGN KEY `Venta_clienteId_fkey`;

-- DropForeignKey
ALTER TABLE `venta` DROP FOREIGN KEY `Venta_usuarioId_fkey`;

-- DropIndex
DROP INDEX `Bitacora_usuarioId_fkey` ON `bitacora`;

-- AlterTable
ALTER TABLE `bitacora` DROP COLUMN `createdAt`,
    DROP COLUMN `detalles`,
    DROP COLUMN `ip`,
    DROP COLUMN `registroId`,
    DROP COLUMN `tabla`,
    DROP COLUMN `usuarioId`,
    ADD COLUMN `descripcion` VARCHAR(191) NOT NULL,
    ADD COLUMN `fecha_hora` DATETIME(3) NOT NULL,
    ADD COLUMN `id_registro_afectado` INTEGER NOT NULL,
    ADD COLUMN `id_sucursal` INTEGER NOT NULL,
    ADD COLUMN `id_usuario` INTEGER NOT NULL,
    ADD COLUMN `ip_origen` VARCHAR(191) NULL,
    ADD COLUMN `navegador` VARCHAR(191) NULL,
    ADD COLUMN `tabla_afectada` VARCHAR(191) NOT NULL,
    MODIFY `accion` VARCHAR(191) NOT NULL;

-- DropTable
DROP TABLE `_productoalmacen`;

-- DropTable
DROP TABLE `_productoproveedor`;

-- DropTable
DROP TABLE `almacen`;

-- DropTable
DROP TABLE `cliente`;

-- DropTable
DROP TABLE `detalleventa`;

-- DropTable
DROP TABLE `movimientoinventario`;

-- DropTable
DROP TABLE `producto`;

-- DropTable
DROP TABLE `proveedor`;

-- DropTable
DROP TABLE `usuario`;

-- DropTable
DROP TABLE `venta`;

-- CreateTable
CREATE TABLE `usuarios` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,
    `correo` VARCHAR(191) NOT NULL,
    `contraseña` VARCHAR(191) NOT NULL,
    `activo` BOOLEAN NOT NULL DEFAULT true,
    `id_rol` INTEGER NOT NULL,

    UNIQUE INDEX `usuarios_correo_key`(`correo`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `roles` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `modulos` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `rol_modulo` (
    `id_rol` INTEGER NOT NULL,
    `id_modulo` INTEGER NOT NULL,
    `puede_crear` BOOLEAN NOT NULL,
    `puede_editar` BOOLEAN NOT NULL,
    `puede_eliminar` BOOLEAN NOT NULL,
    `puede_ver` BOOLEAN NOT NULL,

    PRIMARY KEY (`id_rol`, `id_modulo`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `categorias` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `productos` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `codigo` VARCHAR(191) NOT NULL,
    `descripcion` VARCHAR(191) NOT NULL,
    `precio` DOUBLE NOT NULL,
    `precio_mayoreo` DOUBLE NOT NULL,
    `costo` DOUBLE NOT NULL,
    `iva` DOUBLE NOT NULL,
    `id_categoria` INTEGER NOT NULL,
    `stock` INTEGER NOT NULL,
    `unidad` VARCHAR(191) NOT NULL,
    `modelo` VARCHAR(191) NOT NULL,
    `stock_minimo` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `proveedores` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `producto_proveedor` (
    `id_producto` INTEGER NOT NULL,
    `id_proveedor` INTEGER NOT NULL,
    `precio_compra` DOUBLE NOT NULL,
    `fecha_ultima_compra` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id_producto`, `id_proveedor`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `historial_precios` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_producto` INTEGER NOT NULL,
    `precio_anterior` DOUBLE NOT NULL,
    `precio_nuevo` DOUBLE NOT NULL,
    `fecha_cambio` DATETIME(3) NOT NULL,
    `id_usuario` INTEGER NOT NULL,
    `motivo` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `clientes` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,
    `fecha_alta` DATETIME(3) NOT NULL,
    `fecha_baja` DATETIME(3) NULL,
    `domicilio` VARCHAR(191) NOT NULL,
    `correo` VARCHAR(191) NOT NULL,
    `telefono` VARCHAR(191) NOT NULL,
    `fecha_nacimiento` DATETIME(3) NOT NULL,
    `comentarios` VARCHAR(191) NOT NULL,
    `referencias` VARCHAR(191) NOT NULL,
    `usa_credito` BOOLEAN NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `creditos` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_cliente` INTEGER NOT NULL,
    `credito_total` DOUBLE NOT NULL,
    `disponible` DOUBLE NOT NULL,
    `pagado` DOUBLE NOT NULL,
    `saldo` DOUBLE NOT NULL,
    `estatus` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `creditos_id_cliente_key`(`id_cliente`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `abonos` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_pago` INTEGER NOT NULL,
    `id_cliente` INTEGER NOT NULL,
    `id_credito` INTEGER NOT NULL,
    `importe` DOUBLE NOT NULL,
    `saldo_antes` DOUBLE NOT NULL,
    `saldo_despues` DOUBLE NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `almacenes` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,
    `ubicacion` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sucursales` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,
    `ubicacion` VARCHAR(191) NOT NULL,
    `telefono` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `almacen_sucursal` (
    `id_almacen` INTEGER NOT NULL,
    `id_sucursal` INTEGER NOT NULL,

    PRIMARY KEY (`id_almacen`, `id_sucursal`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `cajas` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_sucursal` INTEGER NOT NULL,
    `nombre` VARCHAR(191) NOT NULL,
    `efectivo` DOUBLE NOT NULL,
    `digital` DOUBLE NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sesion_usuario_caja` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_usuario` INTEGER NOT NULL,
    `id_caja` INTEGER NOT NULL,
    `fecha_hora_inicio` DATETIME(3) NOT NULL,
    `fecha_hora_fin` DATETIME(3) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ventas` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_cliente` INTEGER NOT NULL,
    `id_vendedor` INTEGER NOT NULL,
    `id_corte` INTEGER NULL,
    `id_sucursal` INTEGER NOT NULL,
    `id_usuario` INTEGER NOT NULL,
    `total` DOUBLE NOT NULL,
    `fecha_hora` DATETIME(3) NOT NULL,
    `descuento` DOUBLE NOT NULL,
    `subtotal` DOUBLE NOT NULL,
    `impuestos` DOUBLE NOT NULL,
    `estatus` VARCHAR(191) NOT NULL,
    `id_forma_pago` INTEGER NOT NULL,
    `saldo_deber` DOUBLE NOT NULL,
    `abono` DOUBLE NOT NULL,
    `cambio` DOUBLE NOT NULL,
    `comentarios` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `detalle_ventas` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_venta` INTEGER NOT NULL,
    `id_producto` INTEGER NOT NULL,
    `cantidad` INTEGER NOT NULL,
    `precio` DOUBLE NOT NULL,
    `impuesto` DOUBLE NOT NULL,
    `importe` DOUBLE NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `compras` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `fecha_emision` DATETIME(3) NOT NULL,
    `id_proveedor` INTEGER NOT NULL,
    `subtotal` DOUBLE NOT NULL,
    `descuento` DOUBLE NOT NULL,
    `impuesto` DOUBLE NOT NULL,
    `total` DOUBLE NOT NULL,
    `id_almacen` INTEGER NOT NULL,
    `estatus` VARCHAR(191) NOT NULL,
    `forma_pago` VARCHAR(191) NOT NULL,
    `id_usuario` INTEGER NOT NULL,
    `referencia` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `detalle_compras` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_compra` INTEGER NOT NULL,
    `id_producto` INTEGER NOT NULL,
    `cantidad` INTEGER NOT NULL,
    `precio` DOUBLE NOT NULL,
    `impuesto` DOUBLE NOT NULL,
    `importe` DOUBLE NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `entradas` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `fecha_emision` DATETIME(3) NOT NULL,
    `id_almacen` INTEGER NOT NULL,
    `importe` DOUBLE NOT NULL,
    `observaciones` VARCHAR(191) NOT NULL,
    `id_usuario` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `detalle_entradas` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_entrada` INTEGER NOT NULL,
    `id_producto` INTEGER NOT NULL,
    `cantidad` INTEGER NOT NULL,
    `precio` DOUBLE NOT NULL,
    `importe` DOUBLE NOT NULL,
    `impuesto` DOUBLE NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `salidas` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `fecha` DATETIME(3) NOT NULL,
    `id_almacen` INTEGER NOT NULL,
    `observaciones` VARCHAR(191) NOT NULL,
    `id_usuario` INTEGER NOT NULL,
    `traspaso` BOOLEAN NOT NULL,
    `id_almacen_traspaso` INTEGER NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `detalle_salidas` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_salida` INTEGER NOT NULL,
    `id_producto` INTEGER NOT NULL,
    `cantidad` INTEGER NOT NULL,
    `precio` DOUBLE NOT NULL,
    `importe` DOUBLE NOT NULL,
    `impuesto` DOUBLE NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `cotizaciones` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `fecha_emision` DATETIME(3) NOT NULL,
    `id_vendedor` INTEGER NOT NULL,
    `id_cliente` INTEGER NOT NULL,
    `subtotal` DOUBLE NOT NULL,
    `impuesto` DOUBLE NOT NULL,
    `total` DOUBLE NOT NULL,
    `forma_pago` VARCHAR(191) NOT NULL,
    `tiempo_entrega` VARCHAR(191) NOT NULL,
    `comentarios` VARCHAR(191) NOT NULL,
    `id_usuario` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `flujo_caja` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `concepto` VARCHAR(191) NOT NULL,
    `tipo` VARCHAR(191) NOT NULL,
    `importe` DOUBLE NOT NULL,
    `fecha` DATETIME(3) NOT NULL,
    `hora` DATETIME(3) NOT NULL,
    `id_caja` INTEGER NOT NULL,
    `id_usuario` INTEGER NOT NULL,
    `id_venta` INTEGER NULL,
    `id_corte` INTEGER NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `pagos` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_sucursal` INTEGER NOT NULL,
    `id_cliente` INTEGER NOT NULL,
    `fecha_hora` DATETIME(3) NOT NULL,
    `monto` DOUBLE NOT NULL,
    `id_periodo` INTEGER NOT NULL,
    `id_usuario` INTEGER NOT NULL,
    `id_forma_pago` INTEGER NOT NULL,
    `id_corte` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `periodos` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_sucursal` INTEGER NOT NULL,
    `nombre` VARCHAR(191) NOT NULL,
    `estado` VARCHAR(191) NOT NULL,
    `fecha_inicio` DATETIME(3) NOT NULL,
    `fecha_creacion` DATETIME(3) NOT NULL,
    `importe` DOUBLE NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `cortes` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_sucursal` INTEGER NOT NULL,
    `periodoId` INTEGER NOT NULL,
    `total_efectivo` DOUBLE NOT NULL,
    `total_digital` DOUBLE NOT NULL,
    `total_neto` DOUBLE NOT NULL,
    `fecha_hora` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vendedores` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,
    `comision` DOUBLE NOT NULL,
    `id_usuario` INTEGER NOT NULL,
    `fecha_alta` DATETIME(3) NOT NULL,
    `fecha_baja` DATETIME(3) NULL,

    UNIQUE INDEX `vendedores_id_usuario_key`(`id_usuario`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `formas_pago` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre_pago` VARCHAR(191) NOT NULL,
    `tipo` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `movimientos_inventario` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_producto` INTEGER NOT NULL,
    `id_almacen` INTEGER NOT NULL,
    `fecha` DATETIME(3) NOT NULL,
    `tipo` VARCHAR(191) NOT NULL,
    `cantidad` INTEGER NOT NULL,
    `existencia_antes` INTEGER NOT NULL,
    `costo` DOUBLE NOT NULL,
    `referencia` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `usuarios` ADD CONSTRAINT `usuarios_id_rol_fkey` FOREIGN KEY (`id_rol`) REFERENCES `roles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `rol_modulo` ADD CONSTRAINT `rol_modulo_id_rol_fkey` FOREIGN KEY (`id_rol`) REFERENCES `roles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `rol_modulo` ADD CONSTRAINT `rol_modulo_id_modulo_fkey` FOREIGN KEY (`id_modulo`) REFERENCES `modulos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `productos` ADD CONSTRAINT `productos_id_categoria_fkey` FOREIGN KEY (`id_categoria`) REFERENCES `categorias`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `producto_proveedor` ADD CONSTRAINT `producto_proveedor_id_producto_fkey` FOREIGN KEY (`id_producto`) REFERENCES `productos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `producto_proveedor` ADD CONSTRAINT `producto_proveedor_id_proveedor_fkey` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `historial_precios` ADD CONSTRAINT `historial_precios_id_producto_fkey` FOREIGN KEY (`id_producto`) REFERENCES `productos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `historial_precios` ADD CONSTRAINT `historial_precios_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `creditos` ADD CONSTRAINT `creditos_id_cliente_fkey` FOREIGN KEY (`id_cliente`) REFERENCES `clientes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `abonos` ADD CONSTRAINT `abonos_id_credito_fkey` FOREIGN KEY (`id_credito`) REFERENCES `creditos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `abonos` ADD CONSTRAINT `abonos_id_cliente_fkey` FOREIGN KEY (`id_cliente`) REFERENCES `clientes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `almacen_sucursal` ADD CONSTRAINT `almacen_sucursal_id_almacen_fkey` FOREIGN KEY (`id_almacen`) REFERENCES `almacenes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `almacen_sucursal` ADD CONSTRAINT `almacen_sucursal_id_sucursal_fkey` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cajas` ADD CONSTRAINT `cajas_id_sucursal_fkey` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sesion_usuario_caja` ADD CONSTRAINT `sesion_usuario_caja_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sesion_usuario_caja` ADD CONSTRAINT `sesion_usuario_caja_id_caja_fkey` FOREIGN KEY (`id_caja`) REFERENCES `cajas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ventas` ADD CONSTRAINT `ventas_id_cliente_fkey` FOREIGN KEY (`id_cliente`) REFERENCES `clientes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ventas` ADD CONSTRAINT `ventas_id_vendedor_fkey` FOREIGN KEY (`id_vendedor`) REFERENCES `vendedores`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ventas` ADD CONSTRAINT `ventas_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ventas` ADD CONSTRAINT `ventas_id_sucursal_fkey` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ventas` ADD CONSTRAINT `ventas_id_forma_pago_fkey` FOREIGN KEY (`id_forma_pago`) REFERENCES `formas_pago`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalle_ventas` ADD CONSTRAINT `detalle_ventas_id_venta_fkey` FOREIGN KEY (`id_venta`) REFERENCES `ventas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalle_ventas` ADD CONSTRAINT `detalle_ventas_id_producto_fkey` FOREIGN KEY (`id_producto`) REFERENCES `productos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `compras` ADD CONSTRAINT `compras_id_proveedor_fkey` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `compras` ADD CONSTRAINT `compras_id_almacen_fkey` FOREIGN KEY (`id_almacen`) REFERENCES `almacenes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `compras` ADD CONSTRAINT `compras_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalle_compras` ADD CONSTRAINT `detalle_compras_id_compra_fkey` FOREIGN KEY (`id_compra`) REFERENCES `compras`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalle_compras` ADD CONSTRAINT `detalle_compras_id_producto_fkey` FOREIGN KEY (`id_producto`) REFERENCES `productos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `entradas` ADD CONSTRAINT `entradas_id_almacen_fkey` FOREIGN KEY (`id_almacen`) REFERENCES `almacenes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `entradas` ADD CONSTRAINT `entradas_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalle_entradas` ADD CONSTRAINT `detalle_entradas_id_entrada_fkey` FOREIGN KEY (`id_entrada`) REFERENCES `entradas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalle_entradas` ADD CONSTRAINT `detalle_entradas_id_producto_fkey` FOREIGN KEY (`id_producto`) REFERENCES `productos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `salidas` ADD CONSTRAINT `salidas_id_almacen_fkey` FOREIGN KEY (`id_almacen`) REFERENCES `almacenes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `salidas` ADD CONSTRAINT `salidas_id_almacen_traspaso_fkey` FOREIGN KEY (`id_almacen_traspaso`) REFERENCES `almacenes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `salidas` ADD CONSTRAINT `salidas_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalle_salidas` ADD CONSTRAINT `detalle_salidas_id_salida_fkey` FOREIGN KEY (`id_salida`) REFERENCES `salidas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalle_salidas` ADD CONSTRAINT `detalle_salidas_id_producto_fkey` FOREIGN KEY (`id_producto`) REFERENCES `productos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cotizaciones` ADD CONSTRAINT `cotizaciones_id_vendedor_fkey` FOREIGN KEY (`id_vendedor`) REFERENCES `vendedores`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cotizaciones` ADD CONSTRAINT `cotizaciones_id_cliente_fkey` FOREIGN KEY (`id_cliente`) REFERENCES `clientes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cotizaciones` ADD CONSTRAINT `cotizaciones_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `flujo_caja` ADD CONSTRAINT `flujo_caja_id_caja_fkey` FOREIGN KEY (`id_caja`) REFERENCES `cajas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `flujo_caja` ADD CONSTRAINT `flujo_caja_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `flujo_caja` ADD CONSTRAINT `flujo_caja_id_venta_fkey` FOREIGN KEY (`id_venta`) REFERENCES `ventas`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `flujo_caja` ADD CONSTRAINT `flujo_caja_id_corte_fkey` FOREIGN KEY (`id_corte`) REFERENCES `cortes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `pagos` ADD CONSTRAINT `pagos_id_sucursal_fkey` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `pagos` ADD CONSTRAINT `pagos_id_cliente_fkey` FOREIGN KEY (`id_cliente`) REFERENCES `clientes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `pagos` ADD CONSTRAINT `pagos_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `pagos` ADD CONSTRAINT `pagos_id_forma_pago_fkey` FOREIGN KEY (`id_forma_pago`) REFERENCES `formas_pago`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `pagos` ADD CONSTRAINT `pagos_id_corte_fkey` FOREIGN KEY (`id_corte`) REFERENCES `cortes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `periodos` ADD CONSTRAINT `periodos_id_sucursal_fkey` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cortes` ADD CONSTRAINT `cortes_id_sucursal_fkey` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cortes` ADD CONSTRAINT `cortes_periodoId_fkey` FOREIGN KEY (`periodoId`) REFERENCES `periodos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vendedores` ADD CONSTRAINT `vendedores_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `movimientos_inventario` ADD CONSTRAINT `movimientos_inventario_id_producto_fkey` FOREIGN KEY (`id_producto`) REFERENCES `productos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `movimientos_inventario` ADD CONSTRAINT `movimientos_inventario_id_almacen_fkey` FOREIGN KEY (`id_almacen`) REFERENCES `almacenes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `bitacora` ADD CONSTRAINT `bitacora_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `bitacora` ADD CONSTRAINT `bitacora_id_sucursal_fkey` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
