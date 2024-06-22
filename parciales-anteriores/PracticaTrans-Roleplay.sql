/*Transferir actividades a nueva locación. La empresa ha adquirido una nueva locación
para tours para utilizar cierto equipamiento. Se deberá dar de alta la nueva locación con los
datos que figuran a continuación y transferir todas las actividades de locaciones con
ambientación “SNK” y que utilicen el equipamiento “Equipo de maniobras tridimensionales”
a esta nueva locación.
Nueva locación:
Nombre: Shiganshina District
Ambientación: SNK
Ubicación GPS: POINT(25.083333, -77.333333)
Dirección: Paradis 2013*/

begin; 

insert into locacion (nombre, ambientacion, ubicacion_gps, direccion)values("Shiganshina District", "SNK", POINT(25.083333, -77.333333), "Paradis 2013" );
select max(codigo) into @ultimo_cod
from locacion;

/*1er Forma con inner*/
update actividad act 
inner join locacion loc on act.codigo_locacion = loc.codigo 
set act.codigo_locacion = @ultimo_cod
where act.equipamiento = "Equipo de maniobras tridimensionales" and loc.ambientacion = "SNK";
/*2da Froma subconsulta*/
update actividad set codigo_locacion = @ultimo_cod where equipamiento = "Equipo de maniobras tridimensionales"
and codigo_locacion in (select codigo from locacion where ambientacion = "SNK"
);

commit;



/*Promoción y reemplazo. El encargado “Bertolt Hoover” pasó a ser guía y se contrató un
nuevo empleado para reemplazarlo en las escalas. Se debe dar de alta el nuevo empleado
con los datos que figuran a continuación, reasignar las escalas posteriores al 30 de
noviembre asignadas a “Bertolt Hoover” al nuevo encargado. Cambiar el tipo de “Bertolt
Hoover” de encargado a guía y asígnarle los tours con temática “SNK” que comiencen
posteriores al 30 de noviembre.
Nuevo empleado:
CUIL: 85-85858585-8
Nombre: Armin
Apellido: Arlert
Teléfono: +858-585858585
Categoría: comander
Tipo: encargado*/
select cuil into @cuil
from empleado 
where nombre = "Bertolt" and apellido = "Hoover";
begin; 
insert into empleado values(85858585858,"Armin", "Arlert", "+858-585858585", "comander", "encargado"); 

update escala esc 
set cuil_encargado = 85858585858
where cuil_encargado = @cuil and esc.fecha_hora_ini > "2022-11-30";

update empleado set tipo = "guia" where cuil = @cuil;

update tour 
set cuil_guia = @cuil
where tematica ="SNK" and fecha_hora_salida > "20221130" ;

commit;
/*#### Enunciado
Duplicar tour. El tour 5757 tuvo mucho éxito. Se debe dar de alta un nuevo tour 6060 con
los mismos datos y las mismas escalas a realizarse 4 meses más tarde tanto para el tour
como sus escalas y en lugar del guía de 5757, asignarle el guía que menos tours haya
guiado hasta ahora.*/



begin; 
with cant_tour as (
select cuil_guia, count(*)  cant
from tour
group by cuil_guia)
select cuil_guia into @cuil
from cant_tour 
where cant = (select min(cant) 
from_cant_tour) limit 1; 

insert into tour 
select 6060, ADDDATE(fecha_hora_salida, INTERVAL 4 MONTH), ADDDATE(fecha_hora_regreso, INTERVAL 4 MONTH), 
lugar_salida, precio_unitario_sugerido, vehiculo, tematica, @cuil
from tour 
where tour.nro = 5757;

insert into escala 
select 6060, ADDDATE(fecha_hora_ini, INTERVAL 4 MONTH), ADDDATE(fecha_hora_fin, INTERVAL 4 MONTH), codigo_locacion, nro_actividad, cuil_encargado
from escala 
where nro_tour = 5757; 

commit;

