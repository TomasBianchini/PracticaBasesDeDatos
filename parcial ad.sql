/*B.AD01 - Salas alternativas. Cuando una sala tiene un inconveniente cerca de una presentación la empresa debe de forma urgente organizar la presentación en otra sala alternativa. Para ello se debe crear el procedimiento almacenado salas_alternativas que reciba como parámetro el id de locación y número de sala y rango de fechas donde no podrá utilizarse la sala y por cada presentación ya organizada en dichas fechas devuelva todas las salas que:

1. Sean de la misma locación que la sala a reemplazar

2. Tengan una capacidad superior a la cantidad de entradas vendidas para la presentación

3. La sala tenga estado habilitada

Nota: no es necesario tener en cuenta si la nueva sala ya tiene agendadas presentaciones.

Indicar id y nombre de la locación, número, nombre y capacidad de la sala.

Probar el procedimiento con la sala 1 de la locación 11001, la misma estará en matenimiento desde el 20 de noviembre de 2023 al 30 de noviembre de 2023.*/


USE `convenciones_underground`;
DROP procedure IF EXISTS `salas_alternativas`;

DELIMITER $$
USE `convenciones_underground`$$
CREATE PROCEDURE `salas_alternativas` (in locacion int, in sala int, in desde date, in hasta date)
reads sql data 
BEGIN

with presentaciones_sala as (
select pre.id_locacion, pre.nro_sala, pre.fecha_hora_ini, count(*) cant 
from presentacion pre 
inner join presentacion_entrada p_ent on p_ent.id_locacion = pre.id_locacion and p_ent.nro_sala = pre.nro_sala 
and p_ent.fecha_hora_ini = pre.fecha_hora_ini
where pre.id_locacion = locacion and pre.nro_sala = sala and pre.fecha_hora_ini between desde and hasta 
group by pre.id_locacion, pre.nro_sala, pre.fecha_hora_ini
)
select loc.id, loc.nombre, sa.nro, sa.nombre, sa.capacidad_maxima 
from presentaciones_sala pre_sa
inner join locacion loc on loc.id = pre_sa.id_locacion 
inner join sala sa on sa.id_locacion = loc.id
where sa.capacidad_maxima > pre_sa.cant and sa.estado = "habilitada" and sa.nro <> pre_sa.nro_sala; 


END$$

DELIMITER ;

call salas_alternativas(11001, 1, "2023-11-20" , "2023-11-30");

/*B.AD02 - Presentaciones a reprogramar. Indicar la presentación más popular de cada temática que haya finalizado. Listar temática, nombre y tipo de la presentación, cantidad de entradas vendidas y nombre del evento donde se realizó. Ordenar por cantidad de entradas vendidas descendente y fecha de inicio de la presentación descendente.


Nota: La presentación más popular de una temática es la que más entradas vendidas tiene de todas las presentaciones de esa temática*/ 


with ventas_ent_tematica as(
select eve.tematica,pre.id_locacion, pre.nro_sala, pre.fecha_hora_ini ,count(*) cant 
from evento eve 
inner join presentacion pre on pre.id_evento = eve.id 
inner join presentacion_entrada p_ent on  p_ent.id_locacion = pre.id_locacion and p_ent.nro_sala = pre.nro_sala 
and p_ent.fecha_hora_ini = pre.fecha_hora_ini
where pre.fecha_hora_fin < now() 
group by eve.tematica,pre.id_locacion, pre.nro_sala, pre.fecha_hora_ini
), 
max_tematica as(
select tematica, max(cant) cant_max
from ventas_ent_tematica
group by tematica
)
select v_tema.tematica, pre.nombre,pre.tipo, v_tema.cant, eve.nombre
from max_tematica ma
inner join ventas_ent_tematica v_tema on v_tema.tematica = ma.tematica and v_tema.cant = ma.cant_max
inner join presentacion pre on pre.id_locacion = v_tema.id_locacion
and  pre.nro_sala =v_tema.nro_sala and  pre.fecha_hora_ini  = v_tema.fecha_hora_ini
inner join evento eve on eve.id = pre.id_evento 
order by v_tema.cant desc, pre.fecha_hora_ini desc;




/*B.AD03 - Registro de temáticas de evento y presentadores. La empresa notó que la creciente variabilidad en temáticas hace difícil armar presentaciones adecuadas a las temáticas y siempre hay que revisar eventos pasados. Por ello decidió que se estandarisen las mismas y se registren en los eventos y para los presentadores. Se deberá:

1. Convertir la temática de los eventos en una entidad tematica con un id autoincremental y una descripcion

2. Migrar las temáticas actualmente registradas en evento a la entidad tematica y reemplazar la columna tematica por una CF al id de temática.

3. Agregar una relación NaM de presentador a tematica tematica_presentador.

4. Registrar para cada presentador las temáticas de las que ya ha participado. Para ello revisar las temáticas de los eventos donde realizó una presentación y cargarlas en la tabla tematica_presentador*/ 

CREATE TABLE `convenciones_underground`.`tematica` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`));

ALTER TABLE `convenciones_underground`.`evento` 
ADD COLUMN `id_tematica` INT NULL AFTER `nombre`,
ADD INDEX `fk_evento_tematica_idx` (`id_tematica` ASC) VISIBLE;
;
ALTER TABLE `convenciones_underground`.`evento` 
ADD CONSTRAINT `fk_evento_tematica`
  FOREIGN KEY (`id_tematica`)
  REFERENCES `convenciones_underground`.`tematica` (`id`)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
  
  CREATE TABLE `convenciones_underground`.`tematica_presentador` (
  `id_tematica` INT NOT NULL,
  `id_presentador` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_tematica`, `id_presentador`),
  INDEX `fk_presentador__idx` (`id_presentador` ASC) VISIBLE,
  CONSTRAINT `fk_tematica`
    FOREIGN KEY (`id_tematica`)
    REFERENCES `convenciones_underground`.`tematica` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_presentador_`
    FOREIGN KEY (`id_presentador`)
    REFERENCES `convenciones_underground`.`presentador` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);

  


start transaction; 

insert into tematica (descripcion)
select distinct eve.tematica 
from evento eve;

update evento eve
inner join tematica tem on tem.descripcion = eve.tematica
set eve.id_tematica = tem.id; 


insert into tematica_presentador 
select distinct eve.id_tematica, pre.id 
from presentador pre 
inner join presentador_presentacion pp on pp.id_presentador = pre.id
inner join presentacion pres on  pres.id_locacion = pp.id_locacion and pres.nro_sala = pp.nro_sala 
and pres.fecha_hora_ini = pp.fecha_hora_ini
inner join evento eve on eve.id = pres.id_evento;

commit;

ALTER TABLE `convenciones_underground`.`evento` 
DROP COLUMN `tematica`,
CHANGE COLUMN `id_tematica` `id_tematica` INT NOT NULL ;











