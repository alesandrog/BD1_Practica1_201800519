create database pr1;
use pr1;


create table PROFESION(
cod_prof INT NOT NULL PRIMARY KEY,
nombre varchar(50) NOT NULL UNIQUE
);

create table PAIS(
cod_pais INT NOT NULL PRIMARY KEY,
nombre varchar(50) NOT NULL,
CONSTRAINT PAIS_nombre_u UNIQUE (nombre)
);

create table PUESTO(
cod_puesto INT NOT NULL PRIMARY KEY,
nombre varchar(50) NOT NULL UNIQUE
);

create table DEPARTAMENTO(
cod_depto INT NOT NULL PRIMARY KEY,
nombre varchar(50) NOT NULL ,
CONSTRAINT DEPARTAMENTO_nombre_u UNIQUE (nombre)
);

create table MIEMBRO(
cod_miembro INT NOT NULL PRIMARY KEY,
nombre varchar(100) NOT NULL,
apellido varchar(100) NOT NULL,
edad INT NOT NULL ,
telefono INT,
residencia varchar(100),
PAIS_cod_pais INT NOT NULL,
PROFESION_cod_prof INT NOT NULL,
foreign key(PAIS_cod_pais) references PAIS(cod_pais) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(PROFESION_cod_prof) references PROFESION(cod_prof) ON DELETE CASCADE ON UPDATE CASCADE
);


create table PUESTO_MIEMBRO(
MIEMBRO_cod_miembro INT NOT NULL,
PUESTO_cod_puesto INT NOT NULL,
DEPARTAMENTO_cod_depto INT NOT NULL,
fecha_inicio date NOT NULL,
fecha_fin date,
primary key(MIEMBRO_cod_miembro, PUESTO_cod_puesto, DEPARTAMENTO_cod_depto),
foreign key(MIEMBRO_cod_miembro) references MIEMBRO(cod_miembro) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(PUESTO_cod_puesto) references PUESTO(cod_puesto) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(DEPARTAMENTO_cod_depto) references DEPARTAMENTO(cod_depto) ON DELETE CASCADE ON UPDATE CASCADE
);

create table TIPO_MEDALLA(
cod_tipo INT NOT NULL PRIMARY KEY,
medalla varchar(20) NOT NULL,
CONSTRAINT TIPO_MEDALLA_medalla_u UNIQUE (medalla)
);

create table MEDALLERO(
PAIS_cod_pais INT NOT NULL,
TIPO_MEDALLA_cod_tipo INT NOT NULL,
cantidad_medallas INT NOT NULL,
primary key(PAIS_cod_pais, TIPO_MEDALLA_cod_tipo),
foreign key(PAIS_cod_pais) references PAIS(cod_pais) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(TIPO_MEDALLA_cod_tipo) references TIPO_MEDALLA(cod_tipo) ON DELETE CASCADE ON UPDATE CASCADE
);

create table DISCIPLINA(
cod_disciplina INT NOT NULL PRIMARY KEY,
nombre varchar(50) NOT NULL,
descripcion varchar(150)
);

create table ATLETA(
cod_atleta INT NOT NULL PRIMARY KEY,
nombre varchar(50) NOT NULL,
apellido varchar(50) NOT NULL,
edad INT NOT NULL,
Participaciones varchar(100) NOT NULL,
DISCIPLINA_cod_disciplina INT NOT NULL,
PAIS_cod_pais INT NOT NULL,
constraint ATLETA_cod_disciplina_fk foreign key(DISCIPLINA_cod_disciplina) references DISCIPLINA(cod_disciplina) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(PAIS_cod_pais) references PAIS(cod_pais) ON DELETE CASCADE ON UPDATE CASCADE
);

create table CATEGORIA(
cod_categoria INT NOT NULL PRIMARY KEY,
categoria varchar(50) NOT NULL
);

create table TIPO_PARTICIPACION(
cod_participacion INT NOT NULL PRIMARY KEY,
tipo_participacion varchar(100) NOT NULL
);

create table EVENTO(
cod_evento INT NOT NULL PRIMARY KEY,
fecha date NOT NULL,
ubicacion varchar(50) NOT NULL,
hora time NOT NULL,
DISCIPLINA_cod_disciplina INT NOT NULL,
TIPO_PARTICIPACION_cod_participacion INT NOT NULL,
CATEGORIA_cod_categoria INT NOT NULL,
foreign key (DISCIPLINA_cod_disciplina) references DISCIPLINA(cod_disciplina) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key (TIPO_PARTICIPACION_cod_participacion) references TIPO_PARTICIPACION(cod_participacion) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key (CATEGORIA_cod_categoria) references CATEGORIA(cod_categoria) ON DELETE CASCADE ON UPDATE CASCADE
);



create table EVENTO_ATLETA(
ATLETA_cod_atleta INT NOT NULL,
EVENTO_cod_evento INT NOT NULL,
primary key(ATLETA_cod_atleta, EVENTO_cod_evento),
foreign key (ATLETA_cod_atleta) references ATLETA(cod_atleta) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key (EVENTO_cod_evento) references EVENTO(cod_evento) 
);

create table TELEVISORA(
cod_televisora INT NOT NULL PRIMARY KEY,
nombre varchar(50) NOT NULL
);

create table COSTO_EVENTO(
EVENTO_cod_evento INT NOT NULL,
TELEVISORA_cod_televisora INT NOT NULL,
tarifa INT NOT NULL,
primary key(EVENTO_cod_evento, TELEVISORA_cod_televisora),
foreign key(EVENTO_cod_evento) references EVENTO(cod_evento) ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(TELEVISORA_cod_televisora) references TELEVISORA(cod_televisora) ON DELETE CASCADE ON UPDATE CASCADE
);

/*
2. En la tabla "Evento" se decidi� que la fecha y hora
se trabajar�a en una sola columna. Eliminar las columnas
fecha y hora. Crear columnas fecha_hora con el tipo de dato
DATE
*/

alter table EVENTO drop column fecha;
alter table EVENTO drop column hora;
alter table EVENTO ADD fecha_hora datetime;

select * from evento;


/*
3. Todos los eventos de las olimpiadas deben ser programados
del 24 de julio de 2020 a partir de las 9:00:00 hasta 09 de 
agosto de 2020 hasta las 20:00:00
*/

alter table EVENTO add constraint const_fecha_hora check (fecha_hora >= '2020-08-24 08:00:00' and fecha_hora <= '2020-09-09 17:00:00');

/*
4. Se decidi� que las ubicaci�n de los eventos se registrar�n previamente
en una tabla y que en la tabla "Evento" solo se almacenara la llave for�nea
seg�n el c�digo del registro de la ubicaci�n, para esto debe realizar lo 
siguiente:
    - Crear tabla "SEDE" con Codigo (Integer), Sede (VARCHAR50)
    - Cambiar el tipo de dato de la columna ubicacion de EVENTO
    por Integer
    - Crear una llave foranea en la columna ubicacion de la tabla
    "EVENTO" y referenciarla a la columna codigo de la tabla SEDE
*/
  
create table SEDE(
cod_sede integer NOT NULL PRIMARY KEY,
sede varchar(50) NOT NULL
);
alter table EVENTO alter column ubicacion INT;
alter table EVENTO add constraint SEDE_cod_sede foreign key(ubicacion) references SEDE(cod_sede) ON DELETE CASCADE ON UPDATE CASCADE;

/*
5. Se revis� la informaci�n de los miembros que se tienen actualmente
y antes de que se ingresen a la base de datos el Comit� desea que a
los miembros que no tengan n�mero telef�nico se le ingrese el n�mero
por Default 0 al momento de ser cargados a la base de datos
*/

alter table MIEMBRO add constraint def_telefono DEFAULT 0 FOR telefono;

/*
6
*/

alter table COSTO_EVENTO alter column tarifa decimal(10,2);

/*
7. Generar el script necesario para hacer la inserci�n de datos a las
tablas requeridas
*/


/* ---------------------------------------TABLAS INDEPENDIENTES------------------*/
insert into PAIS values (1 , 'Guatemala');
insert into PAIS values (2 , 'Francia');
insert into PAIS values (3 , 'Argentina');
insert into PAIS values (4 , 'Brasil');
insert into PAIS values (5 , 'España');
insert into PAIS values (6 , 'Portugal');
insert into PAIS values (7 , 'Mexico');
insert into PAIS values (8 , 'Holanda');
insert into PAIS values (9 , 'Italia');
insert into PAIS values (10 , 'Alemania');

SELECT * FROM PAIS ORDER BY cod_pais;

insert into PROFESION values (1 , 'Medico');
insert into PROFESION values (2 , 'Ingeniero');
insert into PROFESION values (3 , 'Secretaria');
insert into PROFESION values (4 , 'Auditor');
insert into PROFESION values (5 , 'Arquitecto');
insert into PROFESION values (6 , 'Contador');
insert into PROFESION values (7 , 'Gerente');
insert into PROFESION values (8 , 'IT');
insert into PROFESION values (9 , 'Programador');
insert into PROFESION values (10 , 'RRRHH');

SELECT * FROM PROFESION ORDER BY cod_prof;


insert into TIPO_MEDALLA values (1, 'Oro');
insert into TIPO_MEDALLA values (2, 'Plata');
insert into TIPO_MEDALLA values (3, 'Bronce');
insert into TIPO_MEDALLA values (4, 'Platino');
insert into TIPO_MEDALLA values (5, 'Cobre');

SELECT * FROM TIPO_MEDALLA;

insert into CATEGORIA values (1, 'Clasificatorio');
insert into CATEGORIA values (2, 'Eliminatorio');
insert into CATEGORIA values (3, 'Octavos');
insert into CATEGORIA values (4, 'Cuartos');
insert into CATEGORIA values (5, 'Semifinal');
insert into CATEGORIA values (6, 'Final');
insert into CATEGORIA values (7, 'Fase grupos');
insert into CATEGORIA values (8, 'Dieciseisavos');
insert into CATEGORIA values (9, '32avos');
insert into CATEGORIA values (10, '3er Lugar');

SELECT * FROM CATEGORIA;


insert into SEDE values (1 , 'Gimnasio');
insert into SEDE values (2 , 'Piscina');
insert into SEDE values (3 , 'Cancha de badminton');
insert into SEDE values (4 , 'Pista de atletismo');
insert into SEDE values (5 , 'Pista de cemento');
insert into SEDE values (6 , 'Cancha de Futbol');
insert into SEDE values (7 , 'Jardin');
insert into SEDE values (8 , 'Estadio Olimpico');
insert into SEDE values (9 , 'Entrada Principal');
insert into SEDE values (10 , 'Diamante');

SELECT * FROM SEDE;


insert into TIPO_PARTICIPACION values (1 , 'Individual');
insert into TIPO_PARTICIPACION values (2 , 'Parejas');
insert into TIPO_PARTICIPACION values (3 , 'Trios');
insert into TIPO_PARTICIPACION values (4 , 'Cuartetos');
insert into TIPO_PARTICIPACION values (5 , 'Grupo');
insert into TIPO_PARTICIPACION values (6 , 'Equipo');
insert into TIPO_PARTICIPACION values (7 , 'Suplente');
insert into TIPO_PARTICIPACION values (8 , 'Quintetos');
insert into TIPO_PARTICIPACION values (9 , 'Sextetos');
insert into TIPO_PARTICIPACION values (10 , 'Online');

SELECT * FROM TIPO_PARTICIPACION;


insert into PUESTO values ( 1 , 'Programador');
insert into PUESTO values ( 2 , 'Secretaria');
insert into PUESTO values ( 3 , 'Auxiliar');
insert into PUESTO values ( 4 , 'Gerente');
insert into PUESTO values ( 5 , 'Camarografo');
insert into PUESTO values ( 6 , 'Diseñador grafico');
insert into PUESTO values ( 7 , 'Publicista');
insert into PUESTO values ( 8 , 'Evaluador');
insert into PUESTO values ( 9 , 'Juez');
insert into PUESTO values ( 10 , 'Medico');


SELECT * FROM PUESTO ORDER BY cod_puesto;

insert into DEPARTAMENTO values ( 1 , 'Publicidad');
insert into DEPARTAMENTO values ( 2 , 'Sistemas');
insert into DEPARTAMENTO values ( 3 , 'Fotografia');
insert into DEPARTAMENTO values ( 4 , 'Planificaion');
insert into DEPARTAMENTO values ( 5 , 'Evento');
insert into DEPARTAMENTO values ( 6 , 'Juez');
insert into DEPARTAMENTO values ( 7 , 'Hospital');
insert into DEPARTAMENTO values ( 8 , 'Diseño');
insert into DEPARTAMENTO values ( 9 , 'Psicologia');
insert into DEPARTAMENTO values ( 10 , 'Nutricion');

SELECT * FROM DEPARTAMENTO ORDER BY cod_depto;

insert into TELEVISORA values ( 1 , 'ESPN');
insert into TELEVISORA values ( 2 , 'FOX SPORTS');
insert into TELEVISORA values ( 3 , 'BEIGN SPORTS');
insert into TELEVISORA values ( 4 , 'TDN');
insert into TELEVISORA values ( 5 , 'TIGO SPORT');
insert into TELEVISORA values ( 6 , 'CLARO SPORT');
insert into TELEVISORA values ( 7 , 'SKY');
insert into TELEVISORA values ( 8 , 'FACEBOOK LIVE');
insert into TELEVISORA values ( 9 , 'NETFLIX');
insert into TELEVISORA values ( 10 , 'CANAL NACIONAL');

SELECT * FROM TELEVISORA;


/*--------------------------TABLAS DEPENDIENTES------------------------------------------*/


insert into MIEMBRO values (1 , 'Glenda' , 'Joachim' , 49, 92211336,  'Western Sahara' , 1 , 5);
insert into MIEMBRO values (2 , 'Tani' , 'Esmaria' , 20, 73683870, 'Puerto Rico' , 6 , 8);
insert into MIEMBRO (cod_miembro , nombre , apellido, edad , residencia , PAIS_cod_pais, PROFESION_cod_prof)
values (3 , 'Roz' , 'Eachern' , 33,  'Dominican Republic' , 9 , 6);
insert into MIEMBRO values (4 , 'Correy' , 'Imelida' , 37, 87730377, 'Moldova, Republic of' , 7 , 3);
insert into MIEMBRO (cod_miembro , nombre , apellido, edad , residencia , PAIS_cod_pais, PROFESION_cod_prof)
values (5 , 'Gloria' , 'Peonir' , 31,  'Chad' , 2 , 8);
insert into MIEMBRO values (6 , 'Madalyn' , 'Lutero' , 37, 71954970, 'Fiji' , 1 , 9);
insert into MIEMBRO (cod_miembro , nombre , apellido, edad , residencia , PAIS_cod_pais, PROFESION_cod_prof)
values (7 , 'Molli' , 'Abram' , 28,  'Zimbabwe' , 8 , 3);
insert into MIEMBRO values (8 , 'Rozele' , 'Laurianne' , 42, 80164390, 'Paraguay' , 7 , 4);
insert into MIEMBRO values (9 , 'Mildrid' , 'Martsen' , 21, 70384813, 'Kazakhstan' , 1 , 8);
insert into MIEMBRO (cod_miembro , nombre , apellido, edad , residencia , PAIS_cod_pais, PROFESION_cod_prof)
values (10 , 'Louella' , 'Oneida' , 46,  'Jamaica' , 9 , 6);


SELECT * FROM MIEMBRO;

insert into DISCIPLINA values (1 , 'Atletismo' , 'Saltos de longitud, altura, prueba de tiempo');
insert into DISCIPLINA (cod_disciplina , nombre ) values (2 , 'Badminton');
insert into DISCIPLINA (cod_disciplina , nombre ) values (3 , 'Vela');
insert into DISCIPLINA (cod_disciplina , nombre ) values (4 , 'Esgrima');
insert into DISCIPLINA values (5 , 'Natacion' , 'Nado Sincronizado');
insert into DISCIPLINA (cod_disciplina , nombre ) values (6 , 'Boxeo');
insert into DISCIPLINA (cod_disciplina , nombre ) values (7 , 'Tenis de mesa');
insert into DISCIPLINA values (8 , 'Futbol' , 'Ronda de 32avos, 16avos, octavos, cuartos, semi, 3er lugar y final');
insert into DISCIPLINA (cod_disciplina , nombre ) values (9 , 'Lucha');
insert into DISCIPLINA (cod_disciplina , nombre ) values (10 , 'Ciclismo');

SELECT * FROM DISCIPLINA;


insert into MEDALLERO values (1,3,5);
insert into MEDALLERO values (5,2,2);
insert into MEDALLERO values (8,5,6);
insert into MEDALLERO values (3,5,9);
insert into MEDALLERO values (6,1,8);
insert into MEDALLERO values (9,3,1);
insert into MEDALLERO values (7,2,7);
insert into MEDALLERO values (4,1,3);
insert into MEDALLERO values (10,5,14);
insert into MEDALLERO values (2,5,36);

SELECT * FROM MEDALLERO;



insert into EVENTO (cod_evento , fecha_hora, ubicacion , DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) 
 values (1, '2020-08-24 11:00:00' , 2 , 2 ,2 , 1);
insert into EVENTO (cod_evento , fecha_hora, ubicacion , DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) 
values (2, '2020-08-27 15:00:00' , 5 , 9 ,6 , 1);
insert into EVENTO (cod_evento , fecha_hora, ubicacion , DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) 
values (3, '2020-08-30 13:00:00' , 1 , 5 ,8 , 3);
insert into EVENTO (cod_evento , fecha_hora, ubicacion , DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) 
values (4, '2020-09-08 09:00:00' , 2 , 5 ,6 , 8);
insert into EVENTO (cod_evento , fecha_hora, ubicacion , DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) 
values (5, '2020-09-09 07:00:00' , 7 , 5 ,3 , 4);
insert into EVENTO (cod_evento , fecha_hora, ubicacion , DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) 
values (6, '2020-09-02 17:00:00' , 12 , 5 ,9 , 7);
insert into EVENTO (cod_evento , fecha_hora, ubicacion , DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) 
values (7, '2020-09-03 20:00:00' , 7 , 8 ,9 , 10);
insert into EVENTO (cod_evento , fecha_hora, ubicacion , DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) 
values (8, '2020-09-27 09:00:00' , 1 , 2 ,3 , 4);
insert into EVENTO (cod_evento , fecha_hora, ubicacion , DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) 
values (9, '2020-08-29 13:00:00' , 5 , 6 ,1 , 7);
insert into EVENTO (cod_evento , fecha_hora, ubicacion , DISCIPLINA_cod_disciplina, TIPO_PARTICIPACION_cod_participacion, CATEGORIA_cod_categoria) 
values (10, '2020-08-31 11:00:00' , 9 , 5 ,1 , 3);

SELECT * FROM EVENTO;



insert into COSTO_EVENTO values ( 1 , 2 , 20.20);
insert into COSTO_EVENTO values ( 3 , 5 , 500.00);
insert into COSTO_EVENTO values ( 6 , 9 , 48.30);
insert into COSTO_EVENTO values ( 7 , 13 , 850);
insert into COSTO_EVENTO values ( 4 , 7 , 60.40);
insert into COSTO_EVENTO values ( 2 , 1 , 98.30);
insert into COSTO_EVENTO values ( 12 , 10 , 1001);
insert into COSTO_EVENTO values ( 5 , 8 , 89.10);
insert into COSTO_EVENTO values ( 8 , 6 , 789);
insert into COSTO_EVENTO values ( 9 , 20 , 4598.20);

SELECT * FROM COSTO_EVENTO;




insert into ATLETA values (1 , 'Maurene' , 'Montgomery', 49, 19, 1 ,8);
insert into ATLETA values (2 , 'Sabina' , 'Prouty', 22, 19, 6 ,5);
insert into ATLETA values (3 , 'Nicoli' , 'Gert', 29, 10, 8 ,9);
insert into ATLETA values (4 , 'Tracey' , 'Doig', 30, 19, 7 ,6);
insert into ATLETA values (5 , 'Taffy' , 'Carlson', 24, 16, 3 ,3);
insert into ATLETA values (6 , 'Brietta' , 'Dorine', 23, 1, 9 ,7);
insert into ATLETA values (7 , 'Jillayne' , 'Cullin', 38, 16, 4 ,1);
insert into ATLETA values (8 , 'Roslyn' , 'Anton', 41, 4, 6 ,2);
insert into ATLETA values (9 , 'Beverley' , 'Waldron', 37, 2, 7 ,5);
insert into ATLETA values (10 , 'Jobi' , 'Sinegold', 30, 3, 8 ,2);

SELECT * FROM ATLETA;


insert into EVENTO_ATLETA values ( 5 , 2 );
insert into EVENTO_ATLETA values ( 8 , 9 );
insert into EVENTO_ATLETA values ( 7 , 10 );
insert into EVENTO_ATLETA values ( 2 , 6 );
insert into EVENTO_ATLETA values ( 1 , 3 );
insert into EVENTO_ATLETA values ( 6 , 13 );
insert into EVENTO_ATLETA values ( 8 , 9 );
insert into EVENTO_ATLETA values ( 6 , 5 );
insert into EVENTO_ATLETA values ( 7 , 9 );
insert into EVENTO_ATLETA values ( 8 , 11 );

insert into PUESTO_MIEMBRO (MIEMBRO_cod_miembro, PUESTO_cod_puesto , DEPARTAMENTO_cod_depto, fecha_inicio) values( 1 ,2 , 3 , '2004-01-01');
insert into PUESTO_MIEMBRO (MIEMBRO_cod_miembro, PUESTO_cod_puesto , DEPARTAMENTO_cod_depto, fecha_inicio)values( 4 ,5 , 6 , '2020-02-28');
insert into PUESTO_MIEMBRO (MIEMBRO_cod_miembro, PUESTO_cod_puesto , DEPARTAMENTO_cod_depto, fecha_inicio)values( 7 ,8 , 9 , '2006-01-02');
insert into PUESTO_MIEMBRO values( 1 ,9 , 3 , '2014-03-13' , '2016-10-20'  );
insert into PUESTO_MIEMBRO (MIEMBRO_cod_miembro, PUESTO_cod_puesto , DEPARTAMENTO_cod_depto, fecha_inicio)values( 3 ,7 , 8 , '2006-09-15');
insert into PUESTO_MIEMBRO (MIEMBRO_cod_miembro, PUESTO_cod_puesto , DEPARTAMENTO_cod_depto, fecha_inicio)values( 7 ,5 , 3 , '2019-08-29');
insert into PUESTO_MIEMBRO (MIEMBRO_cod_miembro, PUESTO_cod_puesto , DEPARTAMENTO_cod_depto, fecha_inicio)values( 1 ,5 , 9 , '2000-04-08');
insert into PUESTO_MIEMBRO values( 2 ,4 , 6 , '2015-04-13' , '2019-01-01');
insert into PUESTO_MIEMBRO (MIEMBRO_cod_miembro, PUESTO_cod_puesto , DEPARTAMENTO_cod_depto, fecha_inicio)values( 8 ,6 , 2 , '2008-12-26');
insert into PUESTO_MIEMBRO (MIEMBRO_cod_miembro, PUESTO_cod_puesto , DEPARTAMENTO_cod_depto, fecha_inicio)values( 4 ,2 , 8 , '2010-07-24');

SELECT * FROM PUESTO_MIEMBRO;
/*
8. Despu�s de que se implement� el script el cu�l cre� todas
las tablas de las bases de datos, el Comit� Ol�mpico Internacional
tom� la decisi�n de eliminar la restricci�n "UNIQUE" de las siguientes
tablas:
    - PAIS -> nombre
    - TIPO_MEDALLA -> medalla
    - DEPARTAMENTO -> nombre
*/

alter table PAIS drop constraint PAIS_nombre_u;
alter table DEPARTAMENTO drop constraint DEPARTAMENTO_nombre_u;
alter table TIPO_MEDALLA drop constraint TIPO_MEDALLA_medalla_u;


/*
9. Despu�s de un an�lisis m�s profundo se decidi� que los Atletas
pueden participar en varias disciplinas y no solo en una sola como
est� reflejado actualmente en las tablas, por lo que se le pide que
realice lo siguiente:
    a. Eliminar llave foranea cod_disciplina en la tabla ATLETA
    b. Script que cree una tabla llamada DISCIPLINA_ATLETA
    que contendr� los siguientes campos:
        cod_atleta
        cod_disciplina
    Ambas primarias
*/


alter table ATLETA drop column DISCIPLINA_cod_disciplina;


CREATE TABLE DISCIPLINA_ATLETA(
ATLETA_cod_atleta INT NOT NULL,
DISCIPLINA_cod_disciplina INT NOT NULL,

primary key (ATLETA_cod_atleta, DISCIPLINA_cod_disciplina),

CONSTRAINT DISCIPLINA_ATLETA_cod_atleta_fk FOREIGN KEY (ATLETA_cod_atleta) REFERENCES ATLETA(cod_atleta) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT DISCIPLINA_ATLETA_cod_disciplina_fk FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina) ON DELETE CASCADE ON UPDATE CASCADE
);

/*
10. Generar el script que borre de la tabla "TIPO_MEDALLA" el registro
    4 Platino
*/

delete from TIPO_MEDALLA where cod_tipo = 4;

SELECT * FROM TIPO_MEDALLA;

/*
11. La fecha de las olimpiadas est� cerca y los preparativos
siguen, pero de �ltimo momento se dieron problemas con las
televisoras encargadas de transmitir los eventos, ya que no hay
tiempo de solucionar los problemas que se dieron, se decidi� no
transmitir el evento a trav�s de las televisoras por lo que el 
Comit� Ol�mpico pide generar el script que elimine la tabla
TELEVISORAS y COSTO EVENTO
*/

delete from COSTO_EVENTO;
delete from TELEVISORA;

SELECT * FROM COSTO_EVENTO;
SELECT * FROM TELEVISORA;

drop table COSTO_EVENTO;
drop table TELEVISORA;


/*
12. El comit� ol�mpico quiere replantear las disciplinas que van a
llevarse a cabo, por lo cual pide generar el script que elimine todos
los registros contenidos en la tabla disciplina
*/

delete from DISCIPLINA;

SELECT * FROM DISCIPLINA;

/*
13. Los miembros que no ten�an registrado su n�mero de tel�fono
en sus perfiles fueron notificados, por lo que se acercaron a las
instalaciones de Comit� para actualizar sus datos
*/

update MIEMBRO set telefono = 55464601 where nombre='Gloria' and apellido='Peonir';

update MIEMBRO set telefono = 91514243 where nombre='Louella' and apellido='Oneida';

update MIEMBRO set telefono = 920686670 where nombre='Roz' and apellido='Eachern';

/*
14. El Comit� decidi� que necesita la fotograf�a en la informaci�n
de los atletas para su perfil, por lo que se debe agreagar la columna
"Fotograf�a" a la tabla Atleta, Debido a que es un cambio de �ltima
hora este campo deber� ser opcional
*/

alter table ATLETA add fotografia varbinary(3000) NULL;
SELECT * FROM ATLETA;

/*
15. Todos los atletas que se registren deben cumplir con
ser menores a 25 a�os. De lo contrario no se debe poder registrar
a un atleta a la base de datos
*/
SELECT * FROM ATLETA;
delete from ATLETA;
alter table ATLETA add constraint ATLETA_const_edad check (edad < 25);

/*/
Registrar 3 atletas mas que coincidan
*/

insert into ATLETA values (1 , 'Nelson' , 'Gonzalez', 20, 19, 1 ,8);
insert into ATLETA values (2 , 'Guillermo' , 'Gonzalez', 22, 19, 6 ,5);
insert into ATLETA values (3 , 'Pedro' , 'Rodriguez', 24, 10, 8 ,9);

SELECT * FROM ATLETA;