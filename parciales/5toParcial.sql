/*301.7- Cree una función **recaudacion_tematica** que dada una temática calcule el ingreso total por evento de esa temática (a través del costo de las entradas) y devuelva el promedio de los mismos. Luego listar los eventos cuya recaudación total supere el promedio de su temática, utilizando dicha función. Indique nombre y temática del evento, recaudación total del mismo, recaudación promedio de la temática y diferencia.*/

USE `convenciones_underground`;
DROP function IF EXISTS `recaudacion_tematica`;

DELIMITER $$
USE `convenciones_underground`$$
CREATE FUNCTION `recaudacion_tematica` (tema varchar(255))
RETURNS decimal(8,3)
reads sql data
BEGIN
declare prom decimal(8,3);
with tema_evento as(
select id, tematica, sum(costo)  total
from evento eve
inner join entrada ent on  ent.id_evento = eve.id
where tematica = tema
group by id, tematica)
select avg(total) into prom 
from tema_evento;

RETURN prom;
END$$

DELIMITER ;

 
 select eve.nombre, eve.tematica, sum(ent.costo), recaudacion_tematica(eve.tematica),  sum(ent.costo)- recaudacion_tematica(eve.tematica)
 from evento eve 
 inner join entrada ent on ent.id_evento = eve.id
 group by eve.nombre, eve.tematica
 having  sum(ent.costo)> recaudacion_tematica(eve.tematica);


