SET SAFETY OFF
CLOSE DATABASES ALL
PUBLIC ubicacion_, nombreusuario, nombre_depa, depclave, nivel_usuario, id_usuario

ubicacion_ = "c:\papeleria\"
nombreusuario = "ADMINISTRA"
nivel_usuario = 2 && Nivel 2 es el Inicio de Administrador
id_usuario = 1 && Es el ID de usuario en la tabla de Usuarios de la Papeleria
nombre_depa = "SISTEMAS"

SET DEFA TO &ubicacion_

SET STATUS BAR ON
SET SYSMENU on
SET DATE DMY
SET CENTURY ON
SET DELETED ON
SET ESCAPE off
SET ENGINEBEHAVIOR 70
SET REPORTBEHAVIOR 90

ubi_papeleria = "C:\Sistemas\PROYECTOS2016\Papeleria"
*ubi_papeleria = "\\SERVIDORP\proyectos2016$\papeleria"
OPEN DATABASE ubi_papeleria+"\papeleria.DBC" SHARED 
ubi_bdcomparte = "C:\Sistemas\BDCOMPARTEP"
*ubi_bdcomparte = "\\SERVIDORP\BDCOMPARTE$"
OPEN DATABASE ubi_bdcomparte+"\COMPARTIDADB.DBC" SHARED 


				*/*/*/*/*/*/* BASE DE DATOS DE PAPELERIA */*/*/*/*/*/*
SELECT 1
USE ubi_papeleria+"\autorizado.dbf" SHARED
SELECT 2
USE ubi_papeleria+"\autorizado_detalle.dbf" SHARED
SELECT 3
USE ubi_papeleria+"\aviso_email.dbf" SHARED
SELECT 4
USE ubi_papeleria+"\configuracion.dbf" SHARED
SELECT 5 
USE ubi_papeleria+"\cotizacion.dbf" SHARED 
SELECT 6
USE ubi_papeleria+"\cotizacion_detalle.dbf" SHARED 
SELECT 7
USE ubi_papeleria+"\cotizacion_obs.dbf" SHARED 
SELECT 8
USE ubi_papeleria+"\departamentos.dbf" SHARED 
SELECT 9
USE ubi_papeleria+"\entrada.dbf" SHARED
SELECT 10
USE ubi_papeleria+"\estatus.dbf" SHARED 
SELECT 11
USE ubi_papeleria+"\factura.dbf" SHARED 
SELECT 12
USE ubi_papeleria+"\forma_de_pago.dbf" SHARED
SELECT 13
USE ubi_papeleria+"\modulos.dbf" SHARED
SELECT 14
USE ubi_papeleria+"\orden_compra.dbf" SHARED 
SELECT 15
USE ubi_papeleria+"\orden_compra_detalle.dbf" SHARED
SELECT 16
USE ubi_papeleria+"\precio_cotizacion.dbf" SHARED 
SELECT 17
USE ubi_papeleria+"\productos.dbf" SHARED 
*SELECT 17
*USE ubi_papeleria+"\productos_medida.dbf" SHARED 
SELECT 18
USE ubi_papeleria+"\salida_almacen.dbf" SHARED 
SELECT 19
USE ubi_papeleria+"\salida_almacen_detalle.dbf" SHARED
SELECT 20
USE ubi_papeleria+"\solicitud.dbf" SHARED 
SELECT 21
USE ubi_papeleria+"\solicitud_detalle.dbf" SHARED 
SELECT 22
USE ubi_papeleria+"\solicitud_justificacion" SHARED 
SELECT 23
USE ubi_papeleria+"\solicitud_obs.dbf" SHARED 
SELECT 24
USE ubi_papeleria+"\unidad_medida.dbf" SHARED 
SELECT 25
USE ubi_papeleria+"\usuarios.dbf" ALIAS usuarios_pape SHARED 
SELECT 26 
USE ubi_papeleria+"\usuarios_modulos.dbf" ALIAS usuarios_pape_modulo SHARED 

				*/*/*/*/*/*/* BASE DE DATOS BDCOMPARTE */*/*/*/*/*/*
				
SELECT 30
USE ubi_bdcomparte+"\Usuarios.dbf" SHARED 
SELECT 31
USE ubi_bdcomparte+"\Meses.dbf" SHARED 


