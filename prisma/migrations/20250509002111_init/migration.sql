/*
  Warnings:

  - Added the required column `costo` to the `Producto` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `producto` ADD COLUMN `costo` DECIMAL(10, 2) NOT NULL;
