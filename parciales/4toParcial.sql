/*301.6- Mantenimiento de Rouge. Se terminó de acondicionar una nueva sala "Blanc" mientras se da mantenimiento a la sala "Rouge". Registar la nueva sala Blanc que terminó de acondicionarse con los siguientes datos, pasar la sala Rouge a estado "en mantenimiento" y reasignar las presentaciones de noviembre de la sala Rouge a Blanc.

Sala:
nombre: Blanc
locación: Rimuru (11001)
Número de sala: 3
metros cuadrados: 330
capacidad: 300
estado: habilitada*/


begin; 

insert into sala (id_locacion, nro, nombre,m2, capacidad_maxima, estado ) values (11001, 3, 'Blanc', 330, 300,'habilitada' );

select nro into @nro_sala
from sala 
where nombre = 'Rouge' and id_locacion = 11001;

update presentacion set nro_sala = 3 where nro_sala = @nro_sala and id_locacion = 11001 and fecha_hora_ini between '20231101' and '20231130';
update sala set estado = 'en mantenimiento' where nro = @nro_sala and id_locacion = 11001;

commit;