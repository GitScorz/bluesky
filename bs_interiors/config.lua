function rotate(input) -- Not sure if needed in component
    return 360 / (10 * input)
end

Config = {
    Interiors = {
        Motel = {
            Spawn = { x = -0.9113941192627, y = -3.4652099609375, z = 1.5 },
            Offsets = {
                exit = { x = -0.9113941192627, y = -3.4652099609375, z = 2.5, h = 0.0 }
            },
            Shell = {
                { object = `playerhouse_hotel`, x = 0, y = 0, z = 0 },
                { object = `V_49_MotelMP_Curtains`, x = 1.55156000, y = -3.83100100, z = 2.23457500 },
                { object = `V_49_MotelMP_Curtains`, x = 1.43190000, y = -3.92315100, z = 2.29329600 },
            },
            Furnished = {
                { object = `playerhouse_hotel`, x = 0, y = 0, z = 0 },
                { object = `v_49_motelmp_stuff`, x = 0, y = 0, z = 0 },
                { object = `v_49_motelmp_bed`, x = 1.4, y = -0.55, z = 0 },
                { object = `v_49_motelmp_clothes`, x = -2.0, y = 2.0, z = 0.15 },
                { object = `v_49_motelmp_winframe`, x = 0.74, y = -4.26, z = 1.11 },
                { object = `v_49_motelmp_glass`, x = 0.74, y = 4.26, z = 1.13 },
                { object = `v_49_motelmp_curtains`, x = 0.74, y = -4.15, z = 0.9 },
                { object = `v_49_motelmp_screen`, x = -2.21, y = -0.6, z = 0.79 },
                { object = `v_res_fa_trainer02r`, x = -1.9, y = 3.0, z = 0.38 },
                { object = `v_res_fa_trainer02l`, x = -2.1, y = 2.95, z = 0.38 },
                { object = `prop_sink_06`, x = 1.1, y = 4.0, z = 0 },
                { object = `prop_chair_04a`, x = 2.1, y = -2.4, z = 0, rot = 270 },
                { object = `prop_chair_04a`, x = 0.7, y = -3.5, z = 0, rot = 180 },
                { object = `prop_kettle`, x = -2.3, y = 0.6, z = 0.9, rot = 90 },
                { object = `Prop_TV_Cabinet_03`, x = -2.3, y = -0.6, z = 0, rot = 90 },
                { object = `prop_tv_06`, x = -2.3, y = -0.6, z = 0.7, rot = 90 },
                { object = `Prop_LD_Toilet_01`, x = 2.1, y = 2.9, z = 0, rot = 270 },
                { object = `Prop_Game_Clock_02`, x = -2.55, y = -0.6, z = 2.0, rot = 90 },
                { object = `v_res_j_phone`, x = 2.4, y = -1.9, z = 0.64, rot = 220 },
                { object = `v_ret_fh_ironbrd`, x = -1.7, y = 3.5, z = 0.15, rot = 90 },
                { object = `prop_iron_01`, x = -1.9, y = 2.85, z = 0.63, rot = 230 },
                { object = `V_Ret_TA_Mug`, x = -2.3, y = 0.95, z = 0.9, rot = 20 },
                { object = `V_Ret_TA_Mug`, x = -2.2, y = 0.9, z = 0.9, rot = 230 },
                { object = `v_res_binder`, x = -2.2, y = 1.3, z = 0.87 },
            },
        },
        Tier1House = {
            Spawn = { x = 3.69693000, y = -15.080020100, z = 1.5 },
            Backdoor = { x = 0.88999176025391, y = 4.3798828125, z = 1.5 },
            Offsets = {
                exit = { x = 4.251012802124, y = -15.901171875, z = 2.5, h = 2.2633972168 },
                backdoor = { x = 0.88999176025391, y = 4.3798828125, z = 2.5, h = 182.2633972168 },
            },
            Shell = {
                { object = `playerhouse_tier1`, x = 0, y = 0, z = 0 },
                { object = `V_16_DT`, x = -1.21854400, y = -1.04389600, z = 1.39068600 }
            },
            Furnished = {
                { object = `playerhouse_tier1_full`, x = 0, y = 0, z = 0 },
                { object = `V_16_DT`, x = -1.21854400, y = -1.04389600, z = 1.39068600 },
                { object = `V_16_mpmidapart01`, x = 0.52447510, y = -5.04953700, z = 1.32 },
                { object = `V_16_mpmidapart09`, x = 0.82202150, y = 2.29612000, z = 1.88 },
                { object = `V_16_mpmidapart07`, x = -1.91445900, y = -6.61911300, z = 1.45 },
                { object = `V_16_mpmidapart03`, x = -4.82565300, y = -6.86803900, z = 1.14 },
                { object = `V_16_midapartdeta`, x = 2.28558400, y = -1.94082100, z = 1.288628 },
                { object = `V_16_treeglow`, x = -1.37408500, y = -0.95420070, z = 1.135 },
                { object = `V_16_midapt_curts`, x = -1.96423300, y = -0.95958710, z = 1.280 },
                { object = `V_16_mpmidapart13`, x = -4.65580700, y = -6.61684000, z = 1.259 },
                { object = `V_16_midapt_cabinet`, x = -1.16177400, y = -0.97333810, z = 1.27 },
                { object = `V_16_midapt_deca`, x = 2.311386000, y = -2.05385900, z = 1.297 },
                { object = `V_16_mid_hall_mesh_delta`, x = 3.69693000, y = -5.80020100, z = 1.293 },
                { object = `V_16_mid_bed_delta`, x = 7.95187400, y = 1.04246500, z = 1.28402300 },
                { object = `V_16_mid_bed_bed`, x = 6.86376900, y = 1.20651200, z = 1.36589100 },
                { object = `V_16_MID_bed_over_decal`, x = 7.82861300, y = 1.04696700, z = 1.34753700 },
                { object = `V_16_mid_bath_mesh_delta`, x = 4.45460500, y = 3.21322800, z = 1.21116100 },
                { object = `V_16_mid_bath_mesh_mirror`, x = 3.57740800, y = 3.25032000, z = 1.48871300 },
                { object = `Prop_CS_Beer_Bot_01`, x = 1.73134600, y = -4.88520200, z = 1.91083000, rot = 90 },
                { object = `v_res_mp_sofa`, x = -1.48765600, y = 1.68100600, z = 1.21640500, rot = -90 },
                { object = `v_res_mp_stripchair`, x = -4.44770800, y = -1.78048800, z = 1.21640500, rot = rotate(0.28045480) },
                { object = `v_res_tre_chair`, x = 2.91325400, y = -5.27835100, z = 1.22746400, rot = rotate(0.3276100) },
                { object = `Prop_Plant_Int_04a`, x = 2.78941300, y = -4.39133900, z = 2.12746400 },
                { object = `v_res_d_lampa`, x = -3.61473100, y = -6.61465100, z = 2.08382800 },
                { object = `v_res_fridgemodsml`, x = 1.90339700, y = -3.80026800, z = 1.29917900, rot = 160 },
                { object = `prop_micro_01`, x = 2.03442400, y = -4.61585100, z = 2.30395600, rot = -80 },
                { object = `V_Res_Tre_SideBoard`, x = 2.84053000, y = -4.30947100, z = 1.24577300, rot = 90 },
                { object = `V_Res_Tre_BedSideTable`, x = -3.50363200, y = -6.55289400, z = 1.30625800, rot = 180 },
                { object = `v_res_d_lampa`, x = 2.69674700, y = -3.83123500, z = 2.09373700 },
                { object = `v_res_tre_tree`, x = -4.96064800, y = -6.09898500, z = 1.31631400 },
                { object = `V_Res_M_DineTble_replace`, x = -3.50712600, y = -4.13621600, z = 1.29625800 },
                { object = `Prop_TV_Flat_01`, x = -5.53120400, y = 0.76299670, z = 2.17236000, rot = 90 },
                { object = `v_res_tre_plant`, x = -5.14112800, y = -2.78951000, z = 1.25950800, rot = 90 },
                { object = `v_res_m_dinechair`, x = -3.04652400, y = -4.95971200, z = 1.19625800, rot = 200 },
                { object = `v_res_m_lampstand`, x = 1.26588400, y = 3.68883900, z = 1.30556700 },
                { object = `V_Res_M_Stool_REPLACED`, x = -3.23216300, y = 2.06159000, z = 1.20556700 },
                { object = `v_res_m_dinechair`, x = -2.82237200, y = -3.59831300, z = 1.25950800, rot = 100 },
                { object = `v_res_m_dinechair`, x = -4.14955100, y = -4.71316600, z = 1.19625800, rot = 135 },
                { object = `v_res_m_dinechair`, x = -3.80622900, y = -3.37648300, z = 1.19625800, rot = 10 },
                { object = `v_res_fa_plant01`, x = 2.97859200, y = 2.55307400, z = 1.85796300 },
                { object = `v_res_tre_storageunit`, x = 8.47819500, y = -2.50979300, z = 1.19712300, rot = 180 },
                { object = `v_res_tre_storagebox`, x = 9.75982700, y = -1.35874100, z = 1.29625800, rot = -90 },
                { object = `v_res_tre_basketmess`, x = 8.70730600, y = -2.55503600, z = 1.94059590 },
                { object = `v_res_m_lampstand`, x = 9.54306000, y = -2.50427700, z = 1.30556700 },
                { object = `Prop_Plant_Int_03a`, x = 9.87521400, y = 3.90917400, z = 1.20829700 },
                { object = `v_res_tre_washbasket`, x = 9.39091500, y = 4.49676300, z = 1.19625800 },
                { object = `V_Res_Tre_Wardrobe`, x = 8.46626300, y = 4.53223600, z = 1.19425800 },
                { object = `v_res_tre_flatbasket`, x = 8.51593000, y = 4.55647300, z = 3.46737300 },
                { object = `v_res_tre_basketmess`, x = 7.57797200, y = 4.55198800, z = 3.46737300 },
                { object = `v_res_tre_flatbasket`, x = 7.12286400, y = 4.54689200, z = 3.46737300 },
                { object = `V_Res_Tre_Wardrobe`, x = 7.24382000, y = 4.53423500, z = 1.19625800 },
                { object = `v_res_tre_flatbasket`, x = 8.03364600, y = 4.54835500, z = 3.46737300 },
                { object = `v_serv_switch_2`, x = 6.28086900, y = -0.68169880, z = 2.30326000 },
                { object = `V_Res_Tre_BedSideTable`, x = 5.84416200, y = 2.57377400, z = 1.22089100, rot = 90 },
                { object = `v_res_d_lampa`, x = 5.84912100, y = 2.58001100, z = 1.95311890 },
                { object = `v_res_mlaundry`, x = 5.77729800, y = 4.60211400, z = 1.19674400 },
                { object = `Prop_ashtray_01`, x = -1.24716200, y = 1.07820500, z = 1.89089300 },
                { object = `v_res_fa_candle03`, x = -2.89289900, y = -4.35329700, z = 2.02881310 },
                { object = `v_res_fa_candle02`, x = -3.99865700, y = -4.06048500, z = 2.02530190 },
                { object = `v_res_fa_candle01`, x = -3.37733400, y = -3.66639800, z = 2.02526200 },
                { object = `v_res_m_woodbowl`, x = -3.50787400, y = -4.11983000, z = 2.02589900 },
                { object = `V_Res_TabloidsA`, x = -0.80513000, y = 0.51389600, z = 1.18418800 },
                { object = `Prop_Tapeplayer_01`, x = -1.26010100, y = -3.62966400, z = 2.37883200, rot = 90 },
                { object = `v_res_tre_fruitbowl`, x = 2.77764900, y = -4.138297000, z = 2.10340100 },
                { object = `v_res_sculpt_dec`, x = 3.03932200, y = 1.62726400, z = 3.58363900 },
                { object = `v_res_jewelbox`, x = 3.04164100, y = 0.31671810, z = 3.58363900 },
                { object = `v_res_tre_basketmess`, x = -1.64906300, y = 1.62675900, z = 1.39038500 },
                { object = `v_res_tre_flatbasket`, x = -1.63938900, y = 0.91133310, z = 1.39038500 },
                { object = `v_res_tre_flatbasket`, x = -1.19923400, y = 1.69598600, z = 1.39038500 },
                { object = `v_res_tre_basketmess`, x = -1.18293800, y = 0.91436380, z = 1.39038500 },
                { object = `v_res_r_sugarbowl`, x = -0.26029210, y = -6.66716800, z = 3.77324900 },
                { object = `Prop_Breadbin_01`, x = 2.09788500, y = -6.57634000, z = 2.24041900 },
                { object = `v_res_mknifeblock`, x = 1.82084700, y = -6.58438500, z = 2.27399500, rot = 180 },
                { object = `prop_toaster_01`, x = -1.05790700, y = -6.59017400, z = 2.26793200 },
                { object = `prop_wok`, x = 2.01728800, y = -5.57091500, z = 2.26793200 },
                { object = `Prop_Plant_Int_03a`, x = 2.55015600, y = 4.60183900, z = 1.20829700 },
                { object = `p_tumbler_cs2_s`, x = -0.90916440, y = -4.24099100, z = 2.26793200 },
                { object = `p_whiskey_bottle_s`, x = -0.92809300, y = -3.99099100, z = 2.26793200 },
                { object = `v_res_tissues`, x = 7.95889300, y = -2.54847100, z = 1.94013400 },
                { object = `V_16_Ap_Mid_Pants4`, x = 7.55366500, y = -0.25457100, z = 1.33009200 },
                { object = `V_16_Ap_Mid_Pants5`, x = 7.76753200, y = 3.00476500, z = 1.33052800 },
                { object = `v_club_vuhairdryer`, x = 8.12616000, y = -2.50562000, z = 1.96009390 },
            },
        },
        Tier2House = {
            Spawn = { x = 0, y = 0, z = 0 },
            Backdoor = { x = 0, y = 0, z = 0 },
            Offsets = {

            },
            Shell = {
                
            },
            Furnished = {
                
            }
        },
        Tier3House = {
            Spawn = { x = 0, y = 0, z = 0 },
            Backdoor = { x = 0, y = 0, z = 0 },
            Offsets = {
                exit = { x = -17.097534179688, y = 7.7457427978516, z = 7.2074546813965, h = 0.0 },
                backdoor = { x = 12.690063476563, y = 12.009414672852, z = 5.8048210144043, h = 0.0 }
            },
            Shell = {
                { object = `playerhouse_tier3`, x = 0, y = 0, z = 0 },
                { object = `v_16_high_lng_over_shadow`, x = 10.16043000, y = -4.83294600, z = 4.99192700 },
            },
            Furnished = {
                
            }
        },
    }
}