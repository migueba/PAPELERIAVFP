FUNCTION enviar_correo (contenido as Character , destinatario as Character )

	TRY
		LOCAL lcSchema, loConfig, loMsg, loError, lcErr
	  	lcErr = ""
	  	lcSchema = "http://schemas.microsoft.com/cdo/configuration/"
	  	loConfig = CREATEOBJECT("CDO.Configuration")
	  	WITH loConfig.FIELDS
	    	.ITEM(lcSchema + "smtpserver") = "smtp.lamaria.com.mx"
	    	.ITEM(lcSchema + "smtpserverport") = 587
	    	
	    	.ITEM(lcSchema + "sendusing") = 2
	    	.ITEM(lcSchema + "smtpauthenticate") = .T. 
	    	*.ITEM(lcSchema + "smtpusessl") = .T. && El correo de la Fabrica no necesita autentificacion SSL
	    	
	    	.ITEM(lcSchema + "sendusername") = "soporte@lamaria.com.mx"
	    	.ITEM(lcSchema + "sendpassword") = "fabmariasc2018"
	    	.UPDATE
	  	ENDWITH
	  	
	  	loMsg = CREATEOBJECT ("CDO.Message")
	  	WITH loMsg
	    	.Configuration = loConfig
	    	.FROM = "Sistema de Papeleria <sistemas2@lamaria.com.mx>"
	    	.TO = destinatario
	    	.Subject = "Soporte Papeleria"
	    	.TextBody = contenido+CHR(13)+CHR(13);
	    		+"Correo enviado automaticamente del Sistema de Papeleria, Favor de no responder este mensaje"
	    	.Send()
	  	ENDWITH
	CATCH TO loError
	  	lcErr = [Error: ] + STR(loError.ERRORNO) + CHR(13) + ;
		[Linea: ] + STR(loError.LINENO) + CHR(13) + ;
		[Mensaje: ] + loError.MESSAGE
	FINALLY
	  	RELEASE loConfig, loMsg
	  	STORE .NULL. TO loConfig, loMsg
	  	IF EMPTY(lcErr)
	   		* MESSAGEBOX("El mensaje se envió con éxito", 64, "Aviso")
	  	ELSE
	    	MESSAGEBOX(lcErr, 16 , "Error")
	  	ENDIF
	ENDTRY
ENDFUNC