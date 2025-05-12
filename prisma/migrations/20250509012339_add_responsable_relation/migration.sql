/*
  Warnings:

  - You are about to drop the column `responsable` on the `almacen` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE `almacen` DROP COLUMN `responsable`,
    ADD COLUMN `responsableId` INTEGER NULL;

-- AddForeignKey
ALTER TABLE `Almacen` ADD CONSTRAINT `Almacen_responsableId_fkey` FOREIGN KEY (`responsableId`) REFERENCES `Usuario`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
