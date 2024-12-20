SELECT 
    O.LINE_NO, 
    O.ORDER_ID,
    N.DEFECT_COUNT,
    DES.FEAT_DESC,
    DES.DESC_DESC,
    CAST(O.INSERT_DATE AS DATE) AS INSERT_DATE,
    TT.MISC1_TXT,
    O.ACC_CD
FROM 
    OWI_STG_INQ_VW.OWI_ORDER_LATEST_REV O

JOIN 
    NCMV.OWI_ORD Q
    ON Q.ORD_ID = O.ORDER_ID

JOIN 
    NCMV.NC_VISIBILITY N
    ON Q.NCCA_KEY = N.NC_KEY

JOIN 
    NCMV.FEAT_DEF_DESC_FULL DES
    ON DES.FEAT_CD = N.FND_FEAT_CD
    AND DES.DESC_CD = N.FND_DESC_CD

JOIN 
    (SELECT 
        T.MISC1_TXT, 
        T.NCCA_KEY
     FROM 
        NCMV.DEF T
     WHERE 
        T.MISC1_TXT IS NOT NULL) AS TT
    ON Q.NCCA_KEY = TT.NCCA_KEY

WHERE 
    O.CVN_ID NOT LIKE '%YP%'
    AND O.ORDER_ID LIKE '%CRO%'
    AND O.ORDER_ID NOT LIKE '%RRMV%'
    AND O.PGM_ID = '737'
    AND O.INSERT_DATE >= '2024-01-01';
