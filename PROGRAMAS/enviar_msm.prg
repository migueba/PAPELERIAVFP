oCom = CREATEOBJECT("MSCOMMLib.MSComm")
 
oCom.CommPort = 1   &&  Estoy usando el puerto 1
 
oCom.Settings = "9600,N,8,1"
 
TRY
 
      IF oCom.PortOpen = .F.
 
          oCom.PortOpen = .T.
 
      ENDIF
 
CATCH
 
      ? 'Error : El puesto está abierto'
 
ENDTRY
 
oCom.Output ="ATZ" + CHR(13)
 
oCom.Output ="AT+CMGF=1" + CHR(13)
 
INKEY(.1)
 
*- Número del Servidor SMS en este caso el de AMENA
 
oCom.Output ="AT+CSCA=+34656000311,145" + CHR(13)
 
INKEY(.1)
 
*- Número de destino al que enviamos el mensaje
 
oCom.Output = "AT+CMGS=" + lcTFDestino + CHR(13)
 
 
*-  Texto que queremos enviar (acabado con CTRL + Z)
 
oCom.Output = lcTexto + CHR(26)+ CHR(13)
 
INKEY(.1)
 
oCom.PortOpen = .F.