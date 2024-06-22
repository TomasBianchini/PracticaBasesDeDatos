/*Crear una función prop_tematica que reciba una temática y un rango de fecha y hora
(desde y hasta) y calcule la proporción de cantidad de entradas contratadas por tours con
dicha temática en el rango propuesto sobre el total de entradas contratadas en el mismo
rango.
Listar todas las temáticas y para cada una invocar a la función para calcular la proporción
entre agosto y diciembre de 2022. Indicar tematica y proporción ordenar por proporción
descendente. No se deben repetir temáticas.*/
USE `role_play_events`;
DROP function IF EXISTS `prop_tematica`;

DELIMITER $$
USE `role_play_events`$$
CREATE FUNCTION `prop_tematica` (tematica_tour varchar(255), fecha_desde datetime, fecha_hasta datetime)
RETURNS decimal(10,3)
 reads sql data
BEGIN
declare prop decimal(10,3); 
select sum(con.cant_entradas) into @total
from tour 
inner join contrata con on con.nro_tour = tour.nro
where fecha_hora_salida >= fecha_desde and fecha_hora_regreso <= fecha_hasta;
select sum(con.cant_entradas)/@total into prop
from tour 
inner join contrata con on con.nro_tour = tour.nro
where fecha_hora_salida >= fecha_desde and fecha_hora_regreso <= fecha_hasta and tematica = tematica_tour;

RETURN prop;
END$$

DELIMITER ;

select distinct tematica, prop_tematica(tematica, '20220801','20221231' )
from tour; 

/*Crear una función llamada idioma_principal que reciba como parámetro una temática e
informe el código idioma más solicitado por cantidad de contratos para dicha temática. Listar
para las temáticas de los tours iniciados en 2022, el idioma principal de cada una invocando
a la función. Indicar, temática, código mediante la función y nombre del idioma principal,
ordenar por temática ascendente. No se deben repetir temáticas.*/
USE `role_play_events`;
DROP function IF EXISTS `idioma_principal`;

DELIMITER $$
USE `role_play_events`$$
CREATE FUNCTION `idioma_principal` (tema varchar(255))
RETURNS INTEGER
reads sql data
BEGIN
declare cod integer; 
with cant as (
select con.codigo_idioma, count(*) as cantidad
from contrata con
inner join tour t on t.nro = con.nro_tour
where t.tematica = tema 
group by con.codigo_idioma
)
select codigo_idioma into cod
from cant 
where cantidad = (select max(cantidad) from cant) limit 1;

RETURN cod;
END$$
DELIMITER ;

select distinct tematica, idioma_principal(tematica), idi.nombre
from tour t 
inner join contrata con on con.nro_tour = t.nro
inner join idioma idi on idi.codigo = con.codigo_idioma 
where idi.codigo = idioma_principal(tematica);




/*Crear un store procedure baja_asistencia que reciba un rango de fechas (desde y hasta)
y liste las temáticas de los tours iniciados entre dicho rango para las que la cantidad total de
asistentes fue menor al 60% de la cantidad total de entradas contratadas. Indicar temática,
fecha de salida del último tour realizado en dicha temática entre el rango de fechas,
cantidad total de entradas contratadas y cantidad de asistentes y porcentaje de asistencia.
Ordenar por porcentaje de asistentes ascendente y temática del tour alfabético.
Invocar el procedimiento para los tours iniciados entre 120 y 30 días atrás.*/
USE `role_play_events`;
DROP procedure IF EXISTS `baja_asistencia`;

DELIMITER $$
USE `role_play_events`$$
CREATE PROCEDURE `baja_asistencia` (desde datetime, hasta datetime)
BEGIN
select t.tematica, max(fecha_hora_salida), sum(con.cant_entradas), 
count(asi.dni_asistente),count(asi.dni_asistente)/ sum(con.cant_entradas)
from tour t 
inner join contrata con on con.nro_toru = t.nro
inner join asistente_contrato asi on asi.nro_tour = con.nro_tour
and asi.cuil_cliente = con.cuil_cliente and asi.fecha_hora = con.fecha_hora
where  fecha_hora_salida between desde and hasta
group by tematica
having count(asi.dni_asistente)/ sum(con.cant_entradas) <0.60;

END
$$

DELIMITER ;


call baja_asistencia('20220607', '20221201')
;
call baja_asistencia_2('20220607', '20221201')
;


