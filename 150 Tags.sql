SELECT
    OD.ncr_ID,
    OD.rev_no,
    OD.orig_ln_no,
    OD.MINOR_MODEL,
    OD.CUSTOMER_NAME,
    OD.INITIATION_DATE,
    OD.LAST_UPD_DT,
    OD.cust_sensitive,
    OD.srl,
    OD.ATA_CD,
    OD.Job_ID,
    OD.job_title,
    OD.rev_stat_cd,
    OD.suppl_nm,
    OD.Description,
    OD.feature,
    OD.item_desc,
    OD.FOUND_LOC_DESC,
    OD.FOUND_SUB_LOC_DESC,
    OD.ROOT_CAUSE_DESC,
    OD.STA,
    OD.WL,
    OD.BL,
    OD.FEATURE || ' ' || OD.Description || ' - ' || OD.FOUND_SUB_LOC_DESC AS DEFECT,
    TXT.DISCREPANCY_TEXT,
    TXT.DISPOSITION_TEXT
FROM
    (SELECT 
        ncr_ID,
        rev_no,
        orig_ln_no,
        MINOR_MODEL,
        CUSTOMER_NAME,
        INITIATION_DATE,
        LAST_UPD_DT,
        cust_sensitive,
        srl,
        ATA_CD,
        Job_ID,
        job_title,
        rev_stat_cd,
        suppl_nm,
        Description,
        feature,
        item_desc,
        FOUND_LOC_DESC,
        FOUND_SUB_LOC_DESC,
        ROOT_CAUSE_DESC,
        STA,
        WL,
        BL,
        FEATURE || ' ' || Description || ' - ' || FOUND_SUB_LOC_DESC AS DEFECT
     FROM 
        OWI_INT_INQ_VW.BIQFD_CC_DETAIL
     WHERE 
        program = '737'
        AND MINOR_MODEL IN ('M8', 'M9', 'MX')
        AND ncr_ID LIKE '%N150%') AS OD

LEFT JOIN 
    (SELECT 
        T.NC_KEY,
        T.NARR_TXT AS DISCREPANCY_TEXT,
        DE.NARR_TXT AS DISPOSITION_TEXT
     FROM 
        NCMV.NCM009_LATEST_DISC_TXT T
     JOIN 
        NCMV.NCM009_LATEST_DISP_TXT DE
        ON DE.NC_KEY = T.NC_KEY) AS TXT
    ON TXT.NC_KEY = OD.ncr_ID;


