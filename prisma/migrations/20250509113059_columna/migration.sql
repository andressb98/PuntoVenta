/*
  Warnings:

  - Added the required column `id_almacen` to the `productos` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `productos` ADD COLUMN `id_almacen` INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE `productos` ADD CONSTRAINT `productos_id_almacen_fkey` FOREIGN KEY (`id_almacen`) REFERENCES `almacenes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
