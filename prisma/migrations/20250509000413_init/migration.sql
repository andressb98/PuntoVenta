/*
  Warnings:

  - Added the required column `codigo` to the `Producto` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `producto` ADD COLUMN `codigo` VARCHAR(255) NOT NULL;
