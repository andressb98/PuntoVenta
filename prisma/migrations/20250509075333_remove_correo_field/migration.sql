/*
  Warnings:

  - You are about to drop the column `correo` on the `usuarios` table. All the data in the column will be lost.

*/
-- DropIndex
DROP INDEX `usuarios_correo_key` ON `usuarios`;

-- AlterTable
ALTER TABLE `usuarios` DROP COLUMN `correo`;
