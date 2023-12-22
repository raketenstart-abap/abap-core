class ZCX_ROOT definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  constants:
    begin of INITIAL_REFERENCE,
      msgid type symsgid value 'ZCORE',
      msgno type symsgno value '000',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INITIAL_REFERENCE .
  constants:
    BEGIN OF sc_msgty.
      CONSTANTS abort   TYPE symsgty VALUE 'A'.
      CONSTANTS error   TYPE symsgty VALUE 'E'.
      CONSTANTS exit    TYPE symsgty VALUE 'X'.
      CONSTANTS info    TYPE symsgty VALUE 'I'.
      CONSTANTS success TYPE symsgty VALUE 'S'.
      CONSTANTS warning TYPE symsgty VALUE 'W'.
    CONSTANTS END OF sc_msgty .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional .
  methods BUILD_BAPIRET
    returning
      value(RESULT) type BAPIRET2 .
  methods BUILD_BAPIRET_TAB
    returning
      value(RESULT) type BAPIRET2_TAB .
  methods RAISE_MESSAGE
    importing
      !MSGTY type SYMSGTY default 'E' .
protected section.
private section.

  aliases T100KEY
    for IF_T100_MESSAGE~T100KEY .
ENDCLASS.



CLASS ZCX_ROOT IMPLEMENTATION.


  METHOD build_bapiret.

    CHECK t100key IS NOT INITIAL.

    cl_message_helper=>set_msg_vars_for_if_msg( me ).

    MESSAGE ID t100key-msgid
          TYPE sc_msgty-error
        NUMBER t100key-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4
          INTO result-message.

    result-id         = t100key-msgid.
    result-type       = sy-msgty.
    result-number     = sy-msgno.
    result-message_v1 = sy-msgv1.
    result-message_v2 = sy-msgv2.
    result-message_v3 = sy-msgv3.
    result-message_v4 = sy-msgv4.

  ENDMETHOD.


  method BUILD_BAPIRET_TAB.
  endmethod.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.


  method RAISE_MESSAGE.
  endmethod.
ENDCLASS.
