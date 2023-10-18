/* Supervisores que no hayan coordinado convenciones. Listar los empleados con categoría supervisor que nunca hayan ocupado el rol de coordinador en un evento de tipo convención. Indicar cuil, nombre, apellido, e email del empleado.*/

select emp.cuil, emp.nombre, emp.apellido, emp.email
from empleado emp 
where emp.categoria = "Supervisor" and emp.cuil not in (
select emp2.cuil
from empleado emp2 
inner join encargado_evento ee on ee.cuil_encargado = emp2.cuil 
inner join evento eve on eve.id = ee.id_evento
where eve.tipo = "convencion" and ee.rol = "Coordinador");

/*301.5- Temáticas exitosas. Listar las temáticas para las que se vendieron más entradas (en total en todos los eventos) este año (2023) que el año pasado (2022) para la misma temática. En caso que el año pasado no se hayan vendido pero este año si debe mostrarse la temática también y asumir la cantidad del año pasado como 0. Indicar temática, cantidad vendida el año pasado, cantidad vendida este año y la diferencia y cuantos compradores distintos las adquirieron este año.*/

with tematicas_entradas_2023 as (
select eve.tematica, count(*) as cant_entradas, count(distinct ent.id_comprador) cant_compradores
from evento eve 
inner join entrada ent on ent.id_evento = eve.id
where year(ent.fecha_hora_venta) = 2023
group by eve.tematica)
select te3.tematica, ifnull(count(ent.fecha_hora_venta), 0) entradas_2022, te3.cant_entradas entradas_2023,
te3.cant_entradas - ifnull(count(ent.fecha_hora_venta), 0) diferencia, te3.cant_compradores
from tematicas_entradas_2023 te3 
inner join evento eve on eve.tematica = te3.tematica
left join entrada ent on ent.id_evento = eve.id and year(ent.fecha_hora_venta) = 2022
group by te3.tematica, te3.cant_entradas, te3.cant_compradores
having count(ent.fecha_hora_venta) < te3.cant_entradas;
















