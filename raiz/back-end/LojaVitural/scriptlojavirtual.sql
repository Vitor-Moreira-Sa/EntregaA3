-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`tipoproduto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tipoproduto` (
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NULL,
  `created_at` TIMESTAMP(1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`status` (
  `id` INT NOT NULL,
  `situacao` TINYINT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`produto` (
  `id` INT NOT NULL,
  `tamanho` VARCHAR(45) NULL,
  `codigo_produto` VARCHAR(45) NULL,
  `tipo` VARCHAR(45) NULL,
  `id_estoque` INT NULL,
  `created_at` TIMESTAMP(1) NULL,
  `tipoproduto_id` INT NOT NULL,
  `status` TINYINT NULL,
  `status_id` INT NOT NULL,
  PRIMARY KEY (`id`, `status_id`),
  INDEX `fk_produto_tipoproduto1_idx` (`tipoproduto_id` ASC) VISIBLE,
  INDEX `fk_produto_status1_idx` (`status_id` ASC) VISIBLE,
  CONSTRAINT `fk_produto_tipoproduto1`
    FOREIGN KEY (`tipoproduto_id`)
    REFERENCES `mydb`.`tipoproduto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_produto_status1`
    FOREIGN KEY (`status_id`)
    REFERENCES `mydb`.`status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`estoque` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `quantidade` VARCHAR(45) NULL,
  `created_at` TIMESTAMP(1) NULL,
  `produto_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_estoque_produto1_idx` (`produto_id` ASC) VISIBLE,
  CONSTRAINT `fk_estoque_produto1`
    FOREIGN KEY (`produto_id`)
    REFERENCES `mydb`.`produto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`gerente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`gerente` (
  `id` INT NOT NULL,
  `nome` VARCHAR(100) NULL,
  `created_at` TIMESTAMP(1) NULL,
  `produto_id` INT NOT NULL,
  `estoque_id` INT NOT NULL,
  PRIMARY KEY (`id`, `produto_id`),
  INDEX `fk_gerente_produto1_idx` (`produto_id` ASC) VISIBLE,
  INDEX `fk_gerente_estoque1_idx` (`estoque_id` ASC) VISIBLE,
  CONSTRAINT `fk_gerente_produto1`
    FOREIGN KEY (`produto_id`)
    REFERENCES `mydb`.`produto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gerente_estoque1`
    FOREIGN KEY (`estoque_id`)
    REFERENCES `mydb`.`estoque` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pedido` (
  `id` INT NOT NULL,
  `id_cliente` INT NULL,
  `id_usuario` INT NULL,
  `data_pedido` VARCHAR(45) NULL,
  `data_venda` VARCHAR(45) NULL,
  `status` VARCHAR(45) NULL,
  `id_pedido_produto` VARCHAR(45) NULL,
  `created_at` TIMESTAMP(1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`endereco` (
  `id` INT NOT NULL,
  `logradouro` VARCHAR(45) NULL,
  `numero` VARCHAR(45) NULL,
  `CEP` VARCHAR(45) NULL,
  `complemento` VARCHAR(45) NULL,
  `cidade` VARCHAR(45) NULL,
  `estado` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`cliente` (
  `id` INT NOT NULL,
  `nome` VARCHAR(100) NULL,
  `endereco` VARCHAR(100) NULL,
  `created_at` TIMESTAMP(1) NULL,
  `id_pedido` INT NULL,
  `pedido_id` INT NOT NULL,
  `endereco_id` INT NOT NULL,
  PRIMARY KEY (`id`, `pedido_id`),
  INDEX `fk_cliente_pedido_idx` (`pedido_id` ASC) VISIBLE,
  UNIQUE INDEX `pedido_id_UNIQUE` (`pedido_id` ASC) VISIBLE,
  INDEX `fk_cliente_endereco1_idx` (`endereco_id` ASC) VISIBLE,
  CONSTRAINT `fk_cliente_pedido`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `mydb`.`pedido` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cliente_endereco1`
    FOREIGN KEY (`endereco_id`)
    REFERENCES `mydb`.`endereco` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`pedido_has_produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pedido_has_produto` (
  `pedido_id` INT NOT NULL,
  `produto_id` INT NOT NULL,
  `created_at` TIMESTAMP(1) NULL,
  PRIMARY KEY (`pedido_id`, `produto_id`),
  INDEX `fk_pedido_has_produto_produto1_idx` (`produto_id` ASC) VISIBLE,
  INDEX `fk_pedido_has_produto_pedido1_idx` (`pedido_id` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_has_produto_pedido1`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `mydb`.`pedido` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_has_produto_produto1`
    FOREIGN KEY (`produto_id`)
    REFERENCES `mydb`.`produto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
