CLASS zcl_core_bapiret_utils DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    CLASS-METHODS build_bapiret
      IMPORTING
        !iv_message       TYPE string
      RETURNING
        VALUE(rs_bapiret) TYPE bapiret2 .
    CLASS-METHODS has_errors
      IMPORTING
        !it_bapiret   TYPE bapirettab
      RETURNING
        VALUE(result) TYPE abap_bool .
    CLASS-METHODS build_bapiret_from_syst
      RETURNING
        VALUE(result) TYPE bapiret2 .
    CLASS-METHODS build_bapiret_from_t100
      IMPORTING
        !io_message   TYPE REF TO if_t100_message
        !iv_msgtyp    TYPE symsgty DEFAULT zcx_root=>sc_msgty-error
      RETURNING
        VALUE(result) TYPE bapiret2 .
    CLASS-METHODS raise_message
      IMPORTING
        !is_bapiret TYPE bapiret2 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CORE_BAPIRET_UTILS IMPLEMENTATION.


  METHOD build_bapiret.

    rs_bapiret-message    = iv_message.
    rs_bapiret-type       = sy-msgty.
    rs_bapiret-id         = sy-msgid.
    rs_bapiret-number     = sy-msgno.
    rs_bapiret-message_v1 = sy-msgv1.
    rs_bapiret-message_v2 = sy-msgv2.
    rs_bapiret-message_v3 = sy-msgv3.
    rs_bapiret-message_v4 = sy-msgv4.

  ENDMETHOD.


  METHOD build_bapiret_from_syst.

    MESSAGE ID sy-msgid
          TYPE sy-msgty
        NUMBER sy-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4
          INTO result-message.

    result-type       = sy-msgty.
    result-id         = sy-msgid.
    result-number     = sy-msgno.
    result-message_v1 = sy-msgv1.
    result-message_v2 = sy-msgv2.
    result-message_v3 = sy-msgv3.
    result-message_v4 = sy-msgv4.

  ENDMETHOD.


  METHOD build_bapiret_from_t100.

    CHECK io_message->t100key IS NOT INITIAL.

    cl_message_helper=>get_t100_text_for(
      obj     = io_message
      t100key = io_message->t100key
    ).

    MESSAGE ID io_message->t100key-msgid
          TYPE iv_msgtyp
         NUMBER io_message->t100key-msgno
           WITH sy-msgv1
                sy-msgv2
                sy-msgv3
                sy-msgv4
           INTO result-message.

    result-type       = sy-msgty.
    result-id         = sy-msgid.
    result-number     = sy-msgno.
    result-message_v1 = sy-msgv1.
    result-message_v2 = sy-msgv2.
    result-message_v3 = sy-msgv3.
    result-message_v4 = sy-msgv4.

  ENDMETHOD.


  METHOD has_errors.

    result = abap_false.

    LOOP AT it_bapiret TRANSPORTING NO FIELDS
      WHERE type = 'E'
         OR type = 'A'
         OR type = 'X'.
      result = abap_true.
      EXIT.
    ENDLOOP.

  ENDMETHOD.


  METHOD raise_message.

    MESSAGE ID is_bapiret-id
          TYPE is_bapiret-type
        NUMBER is_bapiret-number
          WITH is_bapiret-message_v1
               is_bapiret-message_v2
               is_bapiret-message_v3
               is_bapiret-message_v4.

  ENDMETHOD.
ENDCLASS.
