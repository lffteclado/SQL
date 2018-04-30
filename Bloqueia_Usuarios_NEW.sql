--select *  from tbUsuarios where UsuarioAtivo = 'V' ORDER BY CodigoUsuario


update tbUsuarios set UsuarioAtivo = 'F' 
WHERE 

CodigoUsuario != 'ADMINISTRATOR' AND                 
CodigoUsuario != 'AUDITORIA' AND
CodigoUsuario != 'CRIS' AND
CodigoUsuario != 'GLEIDSON3'AND
CodigoUsuario != 'GLEIDSON4' AND                     
CodigoUsuario != 'LUIS4' AND                         
CodigoUsuario != 'MASTER' AND
CodigoUsuario != 'MASTER2'AND
CodigoUsuario != 'MASTER8' AND                       
CodigoUsuario != 'NFE' AND                           
CodigoUsuario != 'NFEFILIAL' AND
CodigoUsuario != 'PRCVDL' AND                        
CodigoUsuario != 'PRCVDL2' AND
CodigoUsuario != 'PRCVDL3' AND                       
CodigoUsuario != 'PRCVDL4' AND                      
CodigoUsuario != 'PRCVDL5' AND                      
CodigoUsuario != 'PRCVDL6' AND                       
CodigoUsuario != 'PRCVDL7' AND                       
CodigoUsuario != 'PRCVDL8' AND                       
CodigoUsuario != 'VENDASVEIC' AND   
CodigoUsuario != 'WBHRH101' AND
CodigoUsuario != 'WBHHOLD' AND   
CodigoUsuario != 'WPECARD1' AND       
CodigoUsuario != 'WPECARD2' AND                      
CodigoUsuario != 'WPECARD3' AND                      
CodigoUsuario != 'WTIADM29'                                                                                             