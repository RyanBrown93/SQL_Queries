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

LEFT JOIN 
    (SELECT
         O.ORDER_KEY,
         O.CVN_ID,
         O.ORDER_ID,
         O.PGM_ID,
         O.LINE_NO,
         O.PLAN_TITLE,
         O.PROD_STATUS_CD
     FROM OWI_INT_INQ_VW.OWI_ORDER_LATEST_REV O
     WHERE O.PGM_ID = '737'
       AND O.ORDER_ID LIKE '%CRO%'
       AND O.ORDER_ID NOT LIKE '%RRMV%'
       AND O.CVN_ID NOT LIKE '%YP%'
    ) AS ORD ON Q.ORD_ID = ORD.ORDER_ID

JOIN 
    (SELECT 
         P.SUM_LAST_UPDT_TS, 
         P.ORDER_KEY
     FROM OWI_INT_INQ_VW.ORDER_STEP_SUM_TXT_RPT P
     WHERE P.SUM_LAST_UPDT_TS BETWEEN '2024-06-04 00:00:00.000000' AND '2024-06-06 00:00:00.000000'
    ) AS TS ON TS.ORDER_KEY = ORD.ORDER_KEY

JOIN 
    (SELECT 
         T.MISC1_TXT, 
         T.NCCA_KEY
     FROM NCMV.DEF T
     WHERE T.MISC1_TXT LIKE '%CQ%' OR T.MISC1_TXT IN ('1', '2', '3', '4')
    ) AS TT ON Q.NCCA_KEY = TT.NCCA_KEY

JOIN 
    (SELECT 
         D.NCCA_KEY, 
         FF.DESC_DESC, 
         FF.FEAT_DESC
     FROM NCMV.DEF D
     JOIN ncmv.feat_def_desc_full FF
         ON D.FND_DESC_CD = FF.DESC_CD
         AND D.FND_FEAT_CD = FF.FEAT_CD
    ) AS FEAT ON TT.NCCA_KEY = FEAT.NCCA_KEY

JOIN 
    NCMV.LATEST_DISC_TXT_DISC_TXT DT ON Q.NCCA_KEY = DT.NC_KEY

WHERE 
    DT.NARR_TXT SIMILAR TO '%(\\*RTS%|\\(RTS\\)%|RETURN TO SHOP%|RTS,%|RTS.%| RTS%|RTS %)%'
    OR ORD.PROD_STATUS_CD = 'RTS';