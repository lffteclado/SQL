FOR EACH sped_movto_msg
    WHERE val_seq_msg_sped = 6478:
    FOR EACH sped_movto_msg_erro of sped_movto_msg:
         DELETE sped_movto_msg_erro.
    END.
    FOR EACH sped_movto_msg_orig of sped_movto_msg:
         DELETE sped_movto_msg_orig.
    END.
    DELETE sped_movto_msg.
END.
