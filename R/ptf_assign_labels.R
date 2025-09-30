ptf_assign_labels <- function(df) {
  label_map <- c(
    # # ---- Metadatos/EC5 (conservo nombres útiles tal cual) ----
    # ec5_uuid = "ec5_uuid",
    # created_at = "created_at",
    # uploaded_at = "uploaded_at",
    # created_by = "created_by",
    # title = "title",

    # # ---- Inicio y datos básicos ----
    # inicio = "1_Inicie",
    # nombre = "2_1_Cmo_es_su_nombre",

    # # ---- Coordenadas (Q3 autorización -> campos de coord) ----
    # latitud = "lat_3_2_Autoriza_a_que_r",
    # longitud = "long_3_2_Autoriza_a_que_r",
    # precision_metros = "accuracy_3_2_Autoriza_a_que_r",
    # norte = "UTM_Northing_3_2_Autoriza_a_que_r",
    # este = "UTM_Easting_3_2_Autoriza_a_que_r",
    # zona = "UTM_Zone_3_2_Autoriza_a_que_r",

    # # ---- Demografía / identidad ----
    edad = "Edad (en años cumplidos)",
    # sexo = "5_4_Sexo_sexo_asigna",
    orientacion_sexual = "Siente atracción sexual o romántica por",
    # orientacion_sexual_otro_txt = "8_Otro_cul",
    # orientacion_sexual_otro_voz = "9_Otro_cul",
    identidad_genero = "Se reconoce como",
    # identidad_genero_otro_txt = "12_Otro_cul",
    # identidad_genero_otro_voz = "13_Otro_cul",
    # etnia = "14_8_De_acuerdo_con_",
    # alfabetismo = "15_9_Sabe_leer_y_esc",
    # educacion = "16_10_Cul_es_el_nive",

    # # ---- Funcionalidad / discapacidad ----
    # oir = "17_11_Or_an_usando_a",
    # oir_causa = "18_111_Or_an_usando_",
    # hablar = "19_12_Hablar_o_conve",
    # hablar_causa = "20_121_Hablar_o_conv",
    # ver = "21_13_Ver_an_usando_",
    # ver_causa = "22_131_Ver_an_usando",
    # moverse = "23_14_Mover_el_cuerp",
    # moverse_causa = "24_141_Mover_el_cuer",
    # manos = "25_15_Agarrar_o_move",
    # manos_causa = "26_151_Agarrar_o_mov",
    # cognitiva = "27_16_Entender_apren",
    # cognitiva_causa = "28_161_Entender_apre",
    # autocuidado = "29_17_Comer_vestirse",
    # autocuidado_causa = "30_171_Comer_vestirs",
    # interaccion = "31_18_Relacionarse_o",
    # interaccion_causa = "32_181_Relacionarse_",
    discapacidad_cnt = "Número de situaciones de discapacidad",
    discapacidad_any = "Alguna situación de discapacidad",

    # afectacion_conflicto = "33_19_Usted_o_algn_m",
    # afectacion_otro_1 = "35_Otro_cul",
    # afectacion_otro_2 = "36_Otro_cul",

    # # seguridad social
    afiliado_riesgos_laborales = "Afiliado a una Administradora de Riesgos Laborales (ARL)",
    cotiza_pension = "Cotiza a pensiones",
    afiliado_salud = "Afiliado al sistema de salud (a una EPS)",
    # regimen_salud = "40_23_A_cul_de_los_s",

    # # ocupación
    # actividad_semana = "41_24_En_qu_activida",
    # actividad_paga_semana = "42_25_Adems_de_lo_an",
    # tenia_trabajo_semana = "43_26_Aunque_no_trab",
    # trabajo_no_remunerado_semana = "44_27_Trabaj_LA_SEMA",
    # busco_trabajo_4_semanas = "45_28_En_las_LTIMAS_",
    # quiere_trabajo = "46_29_Desea_consegui",
    # trabajo_12_meses = "47_30_Durante_los_lt",
    # busco_despues_ultimo_empleo = "48_31_Despus_de_su_l",
    # busco_12_meses = "49_32_Durante_los_lt",
    # disponible_semana = "50_33_Si_le_hubiera_",
    # ocupacion_desc_1 = "52_Qu_hace_en_este_t",
    # ocupacion_desc_2 = "53_Qu_hace_en_este_t",
    mcdo_laboral = "Participación en el mercado laboral",

    # ingreso_principal = "54_35_Cunto_gan_el_M",
    otros_trabajos = "Otros trabajos o negocios que generan ingresos",
    # otros_trabajos_cuales_1 = "57_Otro_cul",
    # otros_trabajos_cuales_2 = "58_Otro_cul",
    # ingreso_otros = "59_37_Cunto_gan_el_M",
    # ingreso_persona = "60_38_Cul_es_el_tota",
    # ingreso_hogar = "61_39_Cul_es_el_tota",
    # ingresos_alcance = "62_40_Los_ingresos_d",
    # gasto_alimentos = "63_41_Cunto_gast_su_",
    # alimentos_sin_compra = "64_42_Durante_el_PAS",
    # alimentos_sin_compra_valor = "65_43_En_cunto_estim",
    # alimentos_sin_compra_origen = "66_44_Cmo_obtuvieron",
    # ayudas_gobierno = "67_45_Durante_los_lt",
    # ayudas_gobierno_otro_1 = "69_Otro_cul",
    # ayudas_gobierno_otro_2 = "70_Otro_cul",
    ayudas_no_gubernamentales = "Recibió ayuda o subsidio de entidades no gubernamentales",
    # ayudas_no_gub_cuales_1 = "73_Otro_cul",
    # ayudas_no_gub_cuales_2 = "74_Otro_cul",

    pertenencia_organizaciones = "Pertenece a alguno de los siguientes grupos, organizaciones o instancias",
    # contacto_organizaciones = "76_48_En_el_ltimo_ao",
    # liderazgo_organizaciones = "77_49_Usted_lidera_p",
    # respeto_inclusion_puntaje = "78_50_Indique_su_niv",
    # discriminacion_motivos = "79_51_Durante_el_PRE",
    # trabajos_mujeres_puntaje = "80_52_Indique_su_niv",
    # amistad_otras_etnias_puntaje = "81_53_Indique_su_niv",
    # trabajar_con_discapacidad_puntaje = "82_54_Indique_su_niv",
    # importancia_familia_puntaje = "84_Familia",
    # importancia_amistades_puntaje = "85_Amistades",
    # importancia_tiempo_libre_puntaje = "86_El_tiempo_libre",
    # importancia_trabajo_puntaje = "87_El_trabajo",
    # importancia_religion_puntaje = "88_La_religin",
    # importancia_politica_puntaje = "89_La_poltica",
    # confianza_familia_puntaje = "91_Familia",
    # confianza_colegas_puntaje = "92_Colegas_de_trabaj",
    # confianza_desconocidos_puntaje = "93_Personas_desconoc",
    # confianza_vecinos_puntaje = "94_Vecinosas",
    # confianza_amistades_puntaje = "95_Amistades",
    # confianza_comunidad_puntaje = "96_Otras_personas_de",
    # confianza_otra_nacionalidad_puntaje = "97_Personas_de_otra_",
    # no_quisiera_vecino = "98_57_De_las_siguien",
    # num_visitas_frecuentes = "99_58_Cuntas_persona",
    # num_apoyos_busqueda = "100_59_Cuntas_person",
    # organizarse_facilidad_puntaje = "101_60_En_una_escala",
    # intermedio = "102_Contine"
    NULL
  )

  for (col in names(df)) {
    if (col %in% names(label_map)) {
      attr(df[[col]], "label") <- label_map[[col]]
    }
  }

  df
}
