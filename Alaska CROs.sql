SELECT 
    CUST.CUST_CD AS Customer,
    O.LINE_NO, 
    N.NC_KEY,
    O.ORDER_ID,
    O.ACC_CD,
    O.ACC_POS_CD,
    O.WORK_LOC_CD,
    DES.FEAT_DESC,
    DES.DESC_DESC,
    CAST(O.MFG_SCH_CMPL_DT AS DATE) AS INSERT_DATE
FROM 
    OWI_STG_INQ_VW.OWI_ORDER_LATEST_REV O

JOIN 
    NCMV.OWI_ORD Q
    ON Q.ORD_ID = O.ORDER_ID

JOIN 
    NCMV.NC_VISIBILITY N
    ON Q.NCCA_KEY = N.NC_KEY

LEFT JOIN 
    NCMV.FEAT_DEF_DESC_FULL DES
    ON DES.FEAT_CD = N.FND_FEAT_CD
    AND DES.DESC_CD = N.FND_DESC_CD

JOIN 
    NCMV.PGM_LN CUST
    ON CUST.LN_NO = O.LINE_NO

WHERE 
    O.LINE_NO = '1980'
    AND O.ORDER_ID NOT LIKE '%RRMV%'
    AND O.PGM_ID = '737'
    AND O.CVN_ID NOT LIKE '%YP%';
