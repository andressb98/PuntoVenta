/*
  Warnings:

  - You are about to drop the column `activo` on the `producto` table. All the data in the column will be lost.
  - You are about to drop the column `almacenId` on the `producto` table. All the data in the column will be lost.
  - You are about to drop the column `iva` on the `producto` table. All the data in the column will be lost.
  - You are about to drop the column `proveedorId` on the `producto` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE `producto` DROP FOREIGN KEY `Producto_almacenId_fkey`;

-- DropForeignKey
ALTER TABLE `producto` DROP FOREIGN KEY `Producto_proveedorId_fkey`;

-- DropIndex
DROP INDEX `Producto_almacenId_fkey` ON `producto`;

-- DropIndex
DROP INDEX `Producto_codigo_key` ON `producto`;

-- DropIndex
DROP INDEX `Producto_proveedorId_fkey` ON `producto`;

-- AlterTable
ALTER TABLE `producto` DROP COLUMN `activo`,
    DROP COLUMN `almacenId`,
    DROP COLUMN `iva`,
    DROP COLUMN `proveedorId`,
    MODIFY `nombre` VARCHAR(255) NOT NULL,
    MODIFY `descripcion` VARCHAR(191) NULL,
    MODIFY `categoria` VARCHAR(100) NOT NULL,
    MODIFY `codigo` VARCHAR(255) NOT NULL;

-- CreateTable
CREATE TABLE `_ProductoProveedor` (
    `A` INTEGER NOT NULL,
    `B` INTEGER NOT NULL,

    UNIQUE INDEX `_ProductoProveedor_AB_unique`(`A`, `B`),
    INDEX `_ProductoProveedor_B_index`(`B`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `_ProductoAlmacen` (
    `A` INTEGER NOT NULL,
    `B` INTEGER NOT NULL,

    UNIQUE INDEX `_ProductoAlmacen_AB_unique`(`A`, `B`),
    INDEX `_ProductoAlmacen_B_index`(`B`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `_ProductoProveedor` ADD CONSTRAINT `_ProductoProveedor_A_fkey` FOREIGN KEY (`A`) REFERENCES `Producto`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_ProductoProveedor` ADD CONSTRAINT `_ProductoProveedor_B_fkey` FOREIGN KEY (`B`) REFERENCES `Proveedor`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_ProductoAlmacen` ADD CONSTRAINT `_ProductoAlmacen_A_fkey` FOREIGN KEY (`A`) REFERENCES `Almacen`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_ProductoAlmacen` ADD CONSTRAINT `_ProductoAlmacen_B_fkey` FOREIGN KEY (`B`) REFERENCES `Producto`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
