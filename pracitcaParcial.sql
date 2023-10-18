/*listado de presentaciones contratadas.
listar para cada presentacion contratada entre enero y julio del 2022 las personas que compraron
 entradas para esa presentacion. indicar id evento, nro de sala, nombre de la presentacion, nombre y 
 apellido de la persona y fecha_hora de venta, fecha_hora_inicio de la presentacion. 
 ordenar alfabeticamente por fecha_venta, apellido y nombre
*/

select pre.id_evento, pre.nro_sala, pre.nombre, per.apellido, ent.fecha_hora_venta, pre.fecha_hora_ini
from presentacion pre 
inner join presentacion_entrada pre_ent on pre.id_locacion = pre_ent.id_locacion
and pre.nro_sala = pre_ent.nro_sala
and pre.fecha_hora_ini = pre_ent.fecha_hora_ini 
inner join entrada ent on ent.nro = pre_ent.nro_entrada and ent.id_evento = pre_ent.id_evento
inner join persona per on per.id = ent.id_comprador
where ent.fecha_hora_venta between '20220101' and '20220631'
order by ent.fecha_hora_venta asc, 4 asc, 3 asc;

/*
Listado de locaciones
listar todas las locaciones y para aquellas que hayan sido contratadas en alguna presentacion entre
 febrero y noviembre del 2023, indicar nombre de la presentacion, descripcion, nro de sala y fecha_hora_inicio. 
mostrar id locacion, nombre_locacion,nombre_presentacion,nro_sala,fecha_hora_inicio.
ordenado por id_locacion, fecha_hora inicio.*/

select loc.id, loc.nombre, pre.nombre,pre.descripcion, pre.nro_sala, pre.fecha_hora_ini
from locacion loc
left join presentacion pre on pre.id_locacion = loc.id and pre.fecha_hora_ini between "20230201" and "20231130"
order by 1 asc,pre.fecha_hora_ini asc;

/*Listado de compradores que no asistieron
listar todas las personas que compraron entradas para un evento y asistio otra persona.
mostrar nombre y apellido de la persona que compro,nombre del evento,
valor base de la entrada y si asistio alguien nombre y apellido del asistidor.
ordenado por nombre y apellido del comprador*/

select per.nombre, per.apellido, eve.nombre, eve.valor_base_entrada, asi.nombre, asi.apellido
from persona per 
inner join entrada ent on ent.id_comprador = per.id
left join persona asi on asi.id = ent.id_asistente
inner join evento eve on eve.id = ent.id_evento
order by 1 asc, 2 asc; 

/*Listar las personas que asistieron a una presentación del presentador Hagane Kurodome, 
durante abril de este año. Indicar id y nombre del evento, nombre de la presentación y del asistente id, 
nombre, apellido y dirección de correo electrónico.
*/

select * 
from presentador pre
inner join presentador_presentacion pre_pre on pre_pre.id_presentador = pre.id
inner join presentacion p 
on p.id_locacion = pre_pre.id_locacion
and p.fecha_hora_ini = pre_pre.fecha_hora_ini 
and p.nro_sala = pre_pre.nro_sala
inner join presentacion_entrada pre_ent on p.id_locacion = pre_ent.id_locacion
and p.fecha_hora_ini = pre_ent.fecha_hora_ini 
and p.nro_sala = pre_ent.nro_sala
inner join entrada ent on ent.id_evento = pre_ent.id_evento and ent.nro = pre_ent.nro_entrada
inner join persona per on per.id = ent.id_asistente
where pre.nombre = "Hagane" and pre.apellido = "Kurodome" and p.fecha_hora_ini between '2023-04-01' and '2023-04-30';


/*Listar las locaciones cuyas salas hayan sido utilizadas en eventos del año 2022 y 
no hayan sido utilizadas en el año 2023 .
*/

select * 
from locacion loc
inner join presentacion pre on pre.id_locacion = loc.id
where year(pre.fecha_hora_ini) = 2022;



/*Calcular el valor para una entrada*/
select ent.id_evento, ent.nro, sum(p.costo_entrada)
from entrada ent
inner join presentacion_entrada pre_ent on ent.nro = pre_ent.nro_entrada and pre_ent.id_evento = ent.id_evento
inner join presentacion p on p.id_locacion = pre_ent.id_locacion
and p.fecha_hora_ini = pre_ent.fecha_hora_ini 
and p.nro_sala = pre_ent.nro_sala
group by 1, 2; 
/*
Locaciones y salas de los eventos de marzo de 2022
Listar las distintas locaciones donde se realizaron eventos 
durante marzo de 2022 según la fecha desde. Indicar nombre, 
dirección y zona de la locación; nro y nombre de la sala. 
Ordenar por zona y nombre de la locación alfabéticamente y descendente por m2 de la sala.
*/

select	loc.nombre, loc.ubicacion_gps, loc.zona, pre.nro_sala, sala.nombre
from locacion loc
inner join presentacion pre on pre.id_locacion = loc.id
inner join sala on sala.id_locacion = pre.id_locacion and sala.nro = pre.nro_sala
inner join evento eve on eve.id = pre.id_evento 
where eve.fecha_desde between '20220301' and '20220331'
order by 3 asc, 1 asc, sala.m2 desc; 

/*
Gold Sponsors y si contrataron stands
Listar los clientes de categoría "Gold Sponsor" y, 
si alguna vez contrataron un stand en la ubicación "área principal" en 2023,
 mostrar para que evento. Indicar cuit y razón social del cliente; id, nombre y temática del evento.
*/

select cli.cuit, cli.razon_social, eve.id, eve.nombre, eve.tematica
from cliente cli 
left join stand sta 
on sta.cuit_cliente = cli.cuit 
and  year(sta.fecha_contrato) = 2023 
and sta.ubicacion = 'Arclienteea principal'
left join evento eve on eve.id = sta.id_evento 
where cli.categoria = "Gold"; 

/*
Locaciones de presentaciones de tipo "role play"
Listar todas las locaciones donde se realizaron presentaciones de tipo "role play". 
Indicar nombre, descripción y fechas de la presentación; 
nombre y dirección de la locación; nombre de sala; id, tipo y nombre del evento.
Ordenar por fecha de inicio del evento descendente y nombre del evento alfabético.*/
select pre.nombre, pre.descripcion, pre.fecha_hora_ini, loc.nombre, loc.ubicacion_gps, sal.nombre, eve.id, 
eve.tipo, eve.nombre 
from presentacion pre 
inner join sala sal on sal.nro = pre.nro_sala and sal.id_locacion = pre.id_locacion 
inner join locacion loc on loc.id = sal.id_locacion
inner join evento eve on eve.id= pre.id_evento
where pre.tipo = "role play"
order by 3 desc, eve.nombre asc;

/*Eventos de Star Wars 2022.. 
Listar los eventos con temática "Star Wars" y  si tuvieron presentaciones en 2022 
(según la fecha y hora de inicio), mostrar datos de las presentaciones y las locaciones.
 Indicar id y nombre del evento; nombre, y fecha y hora de inicio de la presentación; 
 nombre y dirección de la locación.*/

select eve.id, eve.nombre, pre.nombre, pre.fecha_hora_ini, loc.nombre, loc.ubicacion_gps
from evento eve
left join presentacion pre on pre.id_evento = eve.id and year(pre.fecha_hora_ini) = 2022
left join locacion loc on loc.id = pre.id_locacion
where eve.tematica = "Star Wars" ;


select loc.nombre, pre.nombre, pre.tipo
from locacion loc
left join presentacion pre on pre.id_locacion = loc.id
and pre.tipo = 'Exposicion';





/*Salas show room*/
/*Listar las salas en las que se hayan realizado al menos 7 presentaciones de tipo "show". Indicar nombre de la sala;
promedio del costo de la entrada (de la presentación) y diferencia entre el máximo y mínimo costo y cantidad de presentaciones "show" realizadas.*/


select sa.nombre, avg(pre.costo_entrada), max(pre.costo_entrada) - min(pre.costo_entrada), count(*)
from salas sa
inner join presentacion pre on pre.nro_sala = sal.nro_sala and pre.id_locacion = sa.id_locacion
where pre.tipo = "Show"
group by 1
having count(*) >= 7;

/*Varaibles y tablas temporales */



/*
 Listar los clientes con categoría "Gold Sponsor" que nunca hayan alquilado un stand de tipo doble para un evento con temática "Abyss". Indicar cuit, razón social e email.*/
 
 
 select cli.*
 from clientes cli 
 where cli.categoria = "Gold Sponsor" and cli.cuit not in (
 select cli2.cuit 
 from clientes cli2 
 inner join stand st on st.cuil_cliente = cli2.cuit
 inner join evento eve on eve.id = st.id_evento
 where eve.tipo = "Abyss" and st.tipo = "doble"); 
 
 /*Listar las especialidades de los panelistas para las que se realizaron más presentaciones este año (2023) que el año pasado (2022). En caso que el año pasado no se hayan realizado pero este año si debe mostrarse la especialidad también y asumir la cantidad del año pasado como 0. Indicar la especialidad, la cantidad realizada este año, la cantidad realizada el año pasado, la diferencia entre ambas y en cuántas locaciones distintas se presentaron este año.*/


create temporary table especialidad_2022
select pre.especialidad, ifnull(count(*), 0) as cant
from presentador pre
inner join presentador_presentacion pp on pp.id_presentador = pre.id 
where year(pp.fecha_hora_ini) = 2022
group by pre.especialidad; 

drop table if exists especialidad_2023;
create temporary table especialidad_2023
select pre.especialidad, ifnull(count(*), 0) as cant
from presentador pre
inner join presentador_presentacion pp on pp.id_presentador = pre.id 
where year(pp.fecha_hora_ini) = 2023
group by pre.especialidad; 

drop table if exists especialidad_localidades;
create temporary table especialidad_localidades
select pre.especialidad, pp.id_locacion,ifnull(count(*), 0) as cant
from presentador pre
inner join presentador_presentacion pp on pp.id_presentador = pre.id 
inner join presentacion pres on pres.id_locacion = pp.id_locacion and pres.nro_sala  = pp.nro_sala  and
pres.fecha_hora_ini = pp.fecha_hora_ini 
where year(pp.fecha_hora_ini) = 2023
group by pre.especialidad, pp.id_locacion ;  

select * from especialidad_localidades;


select * from especialidad_2023;
select es23.especialidad, es23.cant as "cantidad 2023", ifnull(es22.cant, 0 ) as "cantidad 2022", es23.cant - ifnull(es22.cant, 0 ), el.cant
from especialidad_2023 es23
left join especialidad_2022 es22 on es23.especialidad = es22.especialidad and  es23.cant > es22.cant
inner join especialidad_localidades el on el.especialidad = es23.especialidad;

/*Mejores clientes. Listar las categorías de clientes que alquilaron más stands de tipo doble que de tipo simple. 
 En caso que no hayan alquilado stands de tipo simple debe mostrarse la categoría y asumir la cantidad de stands simples alquilados como 0. 
 Indicar la categoría, cantidad de stands simples alquilados, cantidad de stands dobles alquilados, la diferencia entre ambamos y la cantidad de eventos diferentes donde lo hicieron.*/
 
 
 create temporary table cant_categoria_doble
 select cli.categoria , count(*) cant, count(distinct stand.id_evento)
 from cliente cli
 inner join stand st on st.cuit_cliente = cli.cuit
 where st.tipo = "doble"
 group by cli.categoria; 
 
 create temporary table cant_categoria_simple
 select cli.categoria , count(*) cant
 from cliente cli
 inner join stand st on st.cuit_cliente = cli.cuit
 where st.tipo = "simple"
 group by cli.categoria; 

 create temporary table cant_eventos
 select cli.categoria, eve.id,  count(*) cant
 from cliente cli 
 inner join stand st on st.cuit_cliente = cli.cuit
 inner join evento eve on eve.id = st.id_evento 
 where st.tipo = "simple" or st.tipo = "simple"
 group by cli.categoria, eve.id; 
 
 select ccd.categoria, ccd.cant, ifnull(ccs.cant, 0), ccd.cant - ifnull(ccs.cant, 0), ce.cant
 from  cant_categoria_doble ccd
 left join cant_categoria_simple ccs on ccs.categoria = ccd.categoria and ccd.cant > ccs.cant
 inner join cant_eventos ce on ce.categoria = ccd.categoria; 

 /*Eventos de Star Wars sin sponsors en área principal. 
Listar los eventos con temática "Star Wars" que no hayan tenido ningún stand ubicado en el área principal que fuera alquilado por un cliente en alguna categoría de sponsor 
(por ejemplo Platinum Sponsor, Gold Sponsor, etc). Indicar el id, nombre, tipo y fechas del evento.*/

select eve.id, eve.nombre, eve.tipo, eve.fecha_desde, eve.fecha_hasta
from evento eve
where eve.tematica = "Star Wars" and eve.id not in(
select eve.id 
from evento eve2 
inner join stand st on st.id_evento = eve.id
inner join cliente cli on cli.cuit = st.cuit_cliente
where cli.categoria = "%Sponsor%" and st.ubicacion ="area principal");
 
 
 
 
 
 
  /*Listar las especialidades de los panelistas para las que se realizaron más presentaciones este año (2023) que el año pasado (2022). En caso que el año pasado no se hayan realizado pero este año si debe mostrarse la especialidad también y asumir la cantidad del año pasado como 0. Indicar la especialidad, la cantidad realizada este año, la cantidad realizada el año pasado, la diferencia entre ambas y en cuántas locaciones distintas se presentaron este año.*/
 
 
 with especialidad_2023 as(
 select pre.especialidad, count(*) as cant_presentaciones, count(distinct pp.id_locacion) cant_locaciones
 from presentador pre 
 inner join presentador_presentacion pp on pp.id_presentador = pre.id 
 where pre.especialidad is not null and year(pp.fecha_hora_ini) = 2023
 group by pre.especialidad
), 
especialidad_2022 as(
select pre.especialidad, count(*) cant_presentaciones
from presentador pre 
inner join presentador_presentacion pp on pp.id_presentador = pre.id 
 where pre.especialidad is not null and year(pp.fecha_hora_ini) = 2022
 group by pre.especialidad
)
select esp3.especialidad, esp3.cant_presentaciones, esp3.cant_locaciones,  esp2.cant_presentaciones  '2022', 
 esp3.cant_locaciones- ifnull(esp2.cant_presentaciones , 0 ) diferencia
from especialidad_2023 esp3 
left join especialidad_2022 esp2 on esp3.especialidad = esp2.especialidad and esp3.cant_presentaciones > esp2.cant_presentaciones
;
 
 
  with especialidad_2023 as(
 select pre.especialidad, count(*) as cant_presentaciones, count(distinct pp.id_locacion) cant_locaciones
 from presentador pre 
 inner join presentador_presentacion pp on pp.id_presentador = pre.id 
 where pre.especialidad is not null and year(pp.fecha_hora_ini) = 2023
 group by pre.especialidad
)
select esp3.especialidad, esp3.cant_presentaciones, esp3.cant_locaciones, ifnull(count(pre2.id_presentador) , 0) cant_2022, esp3.cant_locaciones - ifnull(count(pre2.id_presentador) , 0)
from especialidad_2023 esp3 
inner join presentador pre on pre.especialidad = esp3.especialidad
left join presentador_presentacion pre2 on pre2.id_presentador = pre.id and  year(pre2.fecha_hora_ini) = 2022
group by esp3.especialidad
having count(pre2.id_presentador) < esp3.cant_presentaciones;


/*Eventos de Star Wars sin sponsors en área principal. 
Listar los eventos con temática "Star Wars" 
que no hayan tenido ningún stand ubicado en el área principal 
que fuera alquilado por un cliente en alguna categoría de sponsor 
(por ejemplo Platinum Sponsor, Gold Sponsor, etc). Indicar el id, nombre, tipo y fechas del evento.*/
select eve.id idEvento, nombre nombreEvento, tipo tipoEvento, fecha_desde fechaInicioEvento, fecha_hasta fechaFinEvento
from evento eve
where eve.tematica = "Star Wars" and eve.id not in (
select sta.id_evento
from stand sta
inner join cliente cli
on cli.cuit= sta.cuit_cliente
where cli.categoria like "%Sponsor%" and sta.ubicacion = "área principal"  );

/*Clayman Clown 
El supervisor Clayman Clown dejará de supervisar eventos, para reemplazarlo se ha contratado un nuevo empleado: Rimuru Tempest. Darlo de alta en el sistema con los datos que figuran a continuación y asignarlo, con rol de supervisor, a todos los futuros eventos donde Clayman debería ser supervisor.

Nuevo empleado:
cuil: 24242424242
nombre: Rimuru
apellido: Tempest
telefono: 242424242
direccion: Hidden Cave 242
email: rimuru@jurashinrin.ma
fecha de nacimiento: 1992-04-24
categoria: daimaou
*/

begin; 
select cuil into @sup 
from empleado emp where nombre = 'Clayman';

insert into empleado  ( cuil, nombre ,apellido ,telefono ,direccion ,email ,fecha_nac, categoria)
 values(24242424242, 'Rimuru', 'Tempest', '242424242', 'Hidden Cave 242', 'rimuru@jurashinrin.ma', 1992-04-24, 'daimaou');

update encargado_evento ee 
 inner join evento eve on ee.id_evento = eve.id
 set cuil_encargado = 24242424242
 where cuil_encargado = @sup and rol = 'Supervisor' and eve.fecha_desde > curdate() ;
commit; 
