/*
  Warnings:

  - You are about to alter the column `referencia` on the `movimientos_inventario` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `Int`.
  - You are about to drop the `detalle_compras` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `detalle_entradas` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `detalle_salidas` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `detalle_ventas` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `detalle_compras` DROP FOREIGN KEY `detalle_compras_id_compra_fkey`;

-- DropForeignKey
ALTER TABLE `detalle_compras` DROP FOREIGN KEY `detalle_compras_id_producto_fkey`;

-- DropForeignKey
ALTER TABLE `detalle_entradas` DROP FOREIGN KEY `detalle_entradas_id_entrada_fkey`;

-- DropForeignKey
ALTER TABLE `detalle_entradas` DROP FOREIGN KEY `detalle_entradas_id_producto_fkey`;

-- DropForeignKey
ALTER TABLE `detalle_salidas` DROP FOREIGN KEY `detalle_salidas_id_producto_fkey`;

-- DropForeignKey
ALTER TABLE `detalle_salidas` DROP FOREIGN KEY `detalle_salidas_id_salida_fkey`;

-- DropForeignKey
ALTER TABLE `detalle_ventas` DROP FOREIGN KEY `detalle_ventas_id_producto_fkey`;

-- DropForeignKey
ALTER TABLE `detalle_ventas` DROP FOREIGN KEY `detalle_ventas_id_venta_fkey`;

-- AlterTable
ALTER TABLE `movimientos_inventario` MODIFY `referencia` INTEGER NULL;

-- DropTable
DROP TABLE `detalle_compras`;

-- DropTable
DROP TABLE `detalle_entradas`;

-- DropTable
DROP TABLE `detalle_salidas`;

-- DropTable
DROP TABLE `detalle_ventas`;

-- CreateTable
CREATE TABLE `detalles_venta` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_venta` INTEGER NOT NULL,
    `id_producto` INTEGER NOT NULL,
    `cantidad` INTEGER NOT NULL,
    `precio` DOUBLE NOT NULL,
    `descuento` DOUBLE NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `detalles_compra` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_compra` INTEGER NOT NULL,
    `id_producto` INTEGER NOT NULL,
    `cantidad` INTEGER NOT NULL,
    `costo` DOUBLE NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `detalles_entrada` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_entrada` INTEGER NOT NULL,
    `id_producto` INTEGER NOT NULL,
    `cantidad` INTEGER NOT NULL,
    `costo` DOUBLE NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `detalles_salida` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `id_salida` INTEGER NOT NULL,
    `id_producto` INTEGER NOT NULL,
    `cantidad` INTEGER NOT NULL,
    `costo` DOUBLE NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `detalles_venta` ADD CONSTRAINT `detalles_venta_id_venta_fkey` FOREIGN KEY (`id_venta`) REFERENCES `ventas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalles_venta` ADD CONSTRAINT `detalles_venta_id_producto_fkey` FOREIGN KEY (`id_producto`) REFERENCES `productos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalles_compra` ADD CONSTRAINT `detalles_compra_id_compra_fkey` FOREIGN KEY (`id_compra`) REFERENCES `compras`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalles_compra` ADD CONSTRAINT `detalles_compra_id_producto_fkey` FOREIGN KEY (`id_producto`) REFERENCES `productos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalles_entrada` ADD CONSTRAINT `detalles_entrada_id_entrada_fkey` FOREIGN KEY (`id_entrada`) REFERENCES `entradas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalles_entrada` ADD CONSTRAINT `detalles_entrada_id_producto_fkey` FOREIGN KEY (`id_producto`) REFERENCES `productos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `movimientos_inventario` ADD CONSTRAINT `mov_inv_entrada_fkey` FOREIGN KEY (`referencia`) REFERENCES `entradas`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `movimientos_inventario` ADD CONSTRAINT `mov_inv_salida_fkey` FOREIGN KEY (`referencia`) REFERENCES `salidas`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `movimientos_inventario` ADD CONSTRAINT `mov_inv_compra_fkey` FOREIGN KEY (`referencia`) REFERENCES `compras`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `movimientos_inventario` ADD CONSTRAINT `mov_inv_venta_fkey` FOREIGN KEY (`referencia`) REFERENCES `ventas`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalles_salida` ADD CONSTRAINT `detalles_salida_id_salida_fkey` FOREIGN KEY (`id_salida`) REFERENCES `salidas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `detalles_salida` ADD CONSTRAINT `detalles_salida_id_producto_fkey` FOREIGN KEY (`id_producto`) REFERENCES `productos`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
