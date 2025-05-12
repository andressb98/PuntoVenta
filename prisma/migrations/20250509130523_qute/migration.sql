-- DropForeignKey
ALTER TABLE `movimientos_inventario` DROP FOREIGN KEY `mov_inv_compra_fkey`;

-- DropForeignKey
ALTER TABLE `movimientos_inventario` DROP FOREIGN KEY `mov_inv_entrada_fkey`;

-- DropForeignKey
ALTER TABLE `movimientos_inventario` DROP FOREIGN KEY `mov_inv_salida_fkey`;

-- DropForeignKey
ALTER TABLE `movimientos_inventario` DROP FOREIGN KEY `mov_inv_venta_fkey`;

-- DropIndex
DROP INDEX `mov_inv_venta_fkey` ON `movimientos_inventario`;
