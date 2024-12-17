SELECT   
    ORD.PGM_ID,
    TT.MISC1_TXT,
    ORD.LINE_NO,
    ORD.CVN_ID,
    Q.NCCA_KEY,
    Q.REL_WRK_PKG_ID,
    ORD.ORDER_ID,
    ORD.PLAN_TITLE,
    DT.NARR_TXT,
    FEAT.FEAT_DESC,
    FEAT.DESC_DESC,
    ORD.PROD_STATUS_CD,
    CAST(TS.SUM_LAST_UPDT_TS AS DATE) AS INSERT_DATE

FROM 
    NCMV.OWI_ORD Q

JOIN 
    (SELECT 
         NCCA_KEY,
         REL_WRK_PKG_ID
     FROM NCMV.OWI_ORD
     WHERE REL_WRK_PKG_ID IN (
         'IP-0000021675', 'IP-0000021676', 'IP-0000331293', 'IP-0000331289',
         'IP-0000331285', 'IP-0000021674', 'IP-0000331299', 'IP-0000331295',
         'IP-0000331296', 'IP-0000331286', 'IP-0000331287', 'IP-0000331291')
    ) AS QQ ON QQ.NCCA_KEY = Q.NCCA_KEY

LEFT JOIN 
    OWI_INT_INQ_VW.OWI_ORDER_LATEST_REV ORD
    ON Q.ORD_ID = ORD.ORDER_ID
    AND ORD.PGM_ID = '737'
    AND ORD.ORDER_ID LIKE '%CRO%'
    AND ORD.ORDER_ID NOT LIKE '%RRMV%'
    AND ORD.CVN_ID NOT LIKE '%YP%'

JOIN 
    OWI_INT_INQ_VW.ORDER_STEP_SUM_TXT_RPT TS
    ON TS.ORDER_KEY = ORD.ORDER_KEY
    AND TS.SUM_LAST_UPDT_TS > '2024-01-01 00:00:00.00000'

JOIN 
    NCMV.DEF TT
    ON Q.NCCA_KEY = TT.NCCA_KEY
    AND (TT.MISC1_TXT LIKE '%CQ%' OR TT.MISC1_TXT IN ('1', '2', '3', '4'))

JOIN 
    NCMV.DEF D
    ON TT.NCCA_KEY = D.NCCA_KEY

JOIN 
    ncmv.feat_def_desc_full FEAT
    ON D.FND_DESC_CD = FEAT.DESC_CD
    AND D.FND_FEAT_CD = FEAT.FEAT_CD

JOIN 
    NCMV.LATEST_DISC_TXT_DISC_TXT DT
    ON Q.NCCA_KEY = DT.NC_KEY
    AND (DT.NARR_TXT LIKE '%*RTS%' 
         OR DT.NARR_TXT LIKE '%(RTS)%' 
         OR DT.NARR_TXT LIKE '%RETURN TO SHOP%' 
         OR DT.NARR_TXT LIKE '%RTS,%' 
         OR DT.NARR_TXT LIKE '%RTS.%' 
         OR DT.NARR_TXT LIKE '% RTS%' 
         OR DT.NARR_TXT LIKE '%RTS %'
         OR ORD.PROD_STATUS_CD = 'RTS');