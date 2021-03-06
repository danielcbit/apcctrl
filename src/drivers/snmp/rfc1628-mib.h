/*
 * This C header file has been generated by smidump 0.4.3.
 * It is intended to be used with the NET-SNMP package.
 *
 * This header is derived from the UPS-MIB module.
 *
 * $Id: rfc1628-mib.h,v 1.4 2005-11-05 21:10:47 adk0212 Exp $
 */

#ifndef _UPS_MIB_H_
#define _UPS_MIB_H_

/*
 * C type definitions for UPS-MIB::upsIdent.
 */

typedef struct upsIdent {
    u_char    *upsIdentManufacturer;
    size_t    _upsIdentManufacturerLength;
    u_char    *upsIdentModel;
    size_t    _upsIdentModelLength;
    u_char    *upsIdentUPSSoftwareVersion;
    size_t    _upsIdentUPSSoftwareVersionLength;
    u_char    *upsIdentAgentSoftwareVersion;
    size_t    _upsIdentAgentSoftwareVersionLength;
    u_char    *upsIdentName;
    size_t    _upsIdentNameLength;
    u_char    *upsIdentAttachedDevices;
    size_t    _upsIdentAttachedDevicesLength;
    void      *_clientData;		/* pointer to client data structure */

    /* private space to hold actual values */

    u_char    __upsIdentManufacturer[31];
    u_char    __upsIdentModel[63];
    u_char    __upsIdentUPSSoftwareVersion[63];
    u_char    __upsIdentAgentSoftwareVersion[63];
    u_char    __upsIdentName[63];
    u_char    __upsIdentAttachedDevices[63];
} upsIdent_t;

/*
 * C manager interface stubs for UPS-MIB::upsIdent.
 */

extern int
ups_mib_mgr_get_upsIdent(struct snmp_session *s, upsIdent_t **upsIdent);

/*
 * C agent interface stubs for UPS-MIB::upsIdent.
 */

extern int
ups_mib_agt_read_upsIdent(upsIdent_t *upsIdent);
extern int
ups_mib_agt_register_upsIdent();

/*
 * C type definitions for UPS-MIB::upsBattery.
 */

typedef struct upsBattery {
    int32_t   *upsBatteryStatus;
    int32_t   *upsSecondsOnBattery;
    int32_t   *upsEstimatedMinutesRemaining;
    int32_t   *upsEstimatedChargeRemaining;
    int32_t   *upsBatteryVoltage;
    int32_t   *upsBatteryCurrent;
    int32_t   *upsBatteryTemperature;
    void      *_clientData;		/* pointer to client data structure */

    /* private space to hold actual values */

    int32_t   __upsBatteryStatus;
    int32_t   __upsSecondsOnBattery;
    int32_t   __upsEstimatedMinutesRemaining;
    int32_t   __upsEstimatedChargeRemaining;
    int32_t   __upsBatteryVoltage;
    int32_t   __upsBatteryCurrent;
    int32_t   __upsBatteryTemperature;
} upsBattery_t;

/*
 * C manager interface stubs for UPS-MIB::upsBattery.
 */

extern int
ups_mib_mgr_get_upsBattery(struct snmp_session *s, upsBattery_t **upsBattery);

/*
 * C agent interface stubs for UPS-MIB::upsBattery.
 */

extern int
ups_mib_agt_read_upsBattery(upsBattery_t *upsBattery);
extern int
ups_mib_agt_register_upsBattery();

/*
 * C type definitions for UPS-MIB::upsInput.
 */

typedef struct upsInput {
    uint32_t  *upsInputLineBads;
    int32_t   *upsInputNumLines;
    void      *_clientData;		/* pointer to client data structure */

    /* private space to hold actual values */

    uint32_t  __upsInputLineBads;
    int32_t   __upsInputNumLines;
} upsInput_t;

/*
 * C manager interface stubs for UPS-MIB::upsInput.
 */

extern int
ups_mib_mgr_get_upsInput(struct snmp_session *s, upsInput_t **upsInput);

/*
 * C agent interface stubs for UPS-MIB::upsInput.
 */

extern int
ups_mib_agt_read_upsInput(upsInput_t *upsInput);
extern int
ups_mib_agt_register_upsInput();

/*
 * C type definitions for UPS-MIB::upsInputEntry.
 */

typedef struct upsInputEntry {
    int32_t   *upsInputLineIndex;
    int32_t   *upsInputFrequency;
    int32_t   *upsInputVoltage;
    int32_t   *upsInputCurrent;
    int32_t   *upsInputTruePower;
    void      *_clientData;		/* pointer to client data structure */
    struct upsInputEntry *_nextPtr;	/* pointer to next table entry */

    /* private space to hold actual values */

    int32_t   __upsInputLineIndex;
    int32_t   __upsInputFrequency;
    int32_t   __upsInputVoltage;
    int32_t   __upsInputCurrent;
    int32_t   __upsInputTruePower;
} upsInputEntry_t;

/*
 * C manager interface stubs for UPS-MIB::upsInputEntry.
 */

extern int
ups_mib_mgr_get_upsInputEntry(struct snmp_session *s, upsInputEntry_t **upsInputEntry);

/*
 * C agent interface stubs for UPS-MIB::upsInputEntry.
 */

extern int
ups_mib_agt_read_upsInputEntry(upsInputEntry_t *upsInputEntry);
extern int
ups_mib_agt_register_upsInputEntry();

/*
 * C type definitions for UPS-MIB::upsOutput.
 */

typedef struct upsOutput {
    int32_t   *upsOutputSource;
    int32_t   *upsOutputFrequency;
    int32_t   *upsOutputNumLines;
    void      *_clientData;		/* pointer to client data structure */

    /* private space to hold actual values */

    int32_t   __upsOutputSource;
    int32_t   __upsOutputFrequency;
    int32_t   __upsOutputNumLines;
} upsOutput_t;

/*
 * C manager interface stubs for UPS-MIB::upsOutput.
 */

extern int
ups_mib_mgr_get_upsOutput(struct snmp_session *s, upsOutput_t **upsOutput);

/*
 * C agent interface stubs for UPS-MIB::upsOutput.
 */

extern int
ups_mib_agt_read_upsOutput(upsOutput_t *upsOutput);
extern int
ups_mib_agt_register_upsOutput();

/*
 * C type definitions for UPS-MIB::upsOutputEntry.
 */

typedef struct upsOutputEntry {
    int32_t   *upsOutputLineIndex;
    int32_t   *upsOutputVoltage;
    int32_t   *upsOutputCurrent;
    int32_t   *upsOutputPower;
    int32_t   *upsOutputPercentLoad;
    void      *_clientData;		/* pointer to client data structure */
    struct upsOutputEntry *_nextPtr;	/* pointer to next table entry */

    /* private space to hold actual values */

    int32_t   __upsOutputLineIndex;
    int32_t   __upsOutputVoltage;
    int32_t   __upsOutputCurrent;
    int32_t   __upsOutputPower;
    int32_t   __upsOutputPercentLoad;
} upsOutputEntry_t;

/*
 * C manager interface stubs for UPS-MIB::upsOutputEntry.
 */

extern int
ups_mib_mgr_get_upsOutputEntry(struct snmp_session *s, upsOutputEntry_t **upsOutputEntry);

/*
 * C agent interface stubs for UPS-MIB::upsOutputEntry.
 */

extern int
ups_mib_agt_read_upsOutputEntry(upsOutputEntry_t *upsOutputEntry);
extern int
ups_mib_agt_register_upsOutputEntry();

/*
 * C type definitions for UPS-MIB::upsBypass.
 */

typedef struct upsBypass {
    int32_t   *upsBypassFrequency;
    int32_t   *upsBypassNumLines;
    void      *_clientData;		/* pointer to client data structure */

    /* private space to hold actual values */

    int32_t   __upsBypassFrequency;
    int32_t   __upsBypassNumLines;
} upsBypass_t;

/*
 * C manager interface stubs for UPS-MIB::upsBypass.
 */

extern int
ups_mib_mgr_get_upsBypass(struct snmp_session *s, upsBypass_t **upsBypass);

/*
 * C agent interface stubs for UPS-MIB::upsBypass.
 */

extern int
ups_mib_agt_read_upsBypass(upsBypass_t *upsBypass);
extern int
ups_mib_agt_register_upsBypass();

/*
 * C type definitions for UPS-MIB::upsBypassEntry.
 */

typedef struct upsBypassEntry {
    int32_t   *upsBypassLineIndex;
    int32_t   *upsBypassVoltage;
    int32_t   *upsBypassCurrent;
    int32_t   *upsBypassPower;
    void      *_clientData;		/* pointer to client data structure */
    struct upsBypassEntry *_nextPtr;	/* pointer to next table entry */

    /* private space to hold actual values */

    int32_t   __upsBypassLineIndex;
    int32_t   __upsBypassVoltage;
    int32_t   __upsBypassCurrent;
    int32_t   __upsBypassPower;
} upsBypassEntry_t;

/*
 * C manager interface stubs for UPS-MIB::upsBypassEntry.
 */

extern int
ups_mib_mgr_get_upsBypassEntry(struct snmp_session *s, upsBypassEntry_t **upsBypassEntry);

/*
 * C agent interface stubs for UPS-MIB::upsBypassEntry.
 */

extern int
ups_mib_agt_read_upsBypassEntry(upsBypassEntry_t *upsBypassEntry);
extern int
ups_mib_agt_register_upsBypassEntry();

/*
 * C type definitions for UPS-MIB::upsAlarm.
 */

typedef struct upsAlarm {
    uint32_t  *upsAlarmsPresent;
    void      *_clientData;		/* pointer to client data structure */

    /* private space to hold actual values */

    uint32_t  __upsAlarmsPresent;
} upsAlarm_t;

/*
 * C manager interface stubs for UPS-MIB::upsAlarm.
 */

extern int
ups_mib_mgr_get_upsAlarm(struct snmp_session *s, upsAlarm_t **upsAlarm);

/*
 * C agent interface stubs for UPS-MIB::upsAlarm.
 */

extern int
ups_mib_agt_read_upsAlarm(upsAlarm_t *upsAlarm);
extern int
ups_mib_agt_register_upsAlarm();

/*
 * C type definitions for UPS-MIB::upsAlarmEntry.
 */

typedef struct upsAlarmEntry {
    int32_t   *upsAlarmId;
    uint32_t  *upsAlarmDescr;
    size_t    _upsAlarmDescrLength;
    uint32_t  *upsAlarmTime;
    void      *_clientData;		/* pointer to client data structure */
    struct upsAlarmEntry *_nextPtr;	/* pointer to next table entry */

    /* private space to hold actual values */

    int32_t   __upsAlarmId;
    uint32_t  __upsAlarmDescr[128];
    uint32_t  __upsAlarmTime;
} upsAlarmEntry_t;

/*
 * C manager interface stubs for UPS-MIB::upsAlarmEntry.
 */

extern int
ups_mib_mgr_get_upsAlarmEntry(struct snmp_session *s, upsAlarmEntry_t **upsAlarmEntry);

/*
 * C agent interface stubs for UPS-MIB::upsAlarmEntry.
 */

extern int
ups_mib_agt_read_upsAlarmEntry(upsAlarmEntry_t *upsAlarmEntry);
extern int
ups_mib_agt_register_upsAlarmEntry();

/*
 * C type definitions for UPS-MIB::upsTest.
 */

typedef struct upsTest {
    uint32_t  *upsTestId;
    size_t    _upsTestIdLength;
    int32_t   *upsTestSpinLock;
    int32_t   *upsTestResultsSummary;
    u_char    *upsTestResultsDetail;
    size_t    _upsTestResultsDetailLength;
    uint32_t  *upsTestStartTime;
    int32_t   *upsTestElapsedTime;
    void      *_clientData;		/* pointer to client data structure */

    /* private space to hold actual values */

    uint32_t  __upsTestId[128];
    int32_t   __upsTestSpinLock;
    int32_t   __upsTestResultsSummary;
    u_char    __upsTestResultsDetail[255];
    uint32_t  __upsTestStartTime;
    int32_t   __upsTestElapsedTime;
} upsTest_t;

/*
 * C manager interface stubs for UPS-MIB::upsTest.
 */

extern int
ups_mib_mgr_get_upsTest(struct snmp_session *s, upsTest_t **upsTest);

/*
 * C agent interface stubs for UPS-MIB::upsTest.
 */

extern int
ups_mib_agt_read_upsTest(upsTest_t *upsTest);
extern int
ups_mib_agt_register_upsTest();

/*
 * C type definitions for UPS-MIB::upsControl.
 */

typedef struct upsControl {
    int32_t   *upsShutdownType;
    int32_t   *upsShutdownAfterDelay;
    int32_t   *upsStartupAfterDelay;
    int32_t   *upsRebootWithDuration;
    int32_t   *upsAutoRestart;
    void      *_clientData;		/* pointer to client data structure */

    /* private space to hold actual values */

    int32_t   __upsShutdownType;
    int32_t   __upsShutdownAfterDelay;
    int32_t   __upsStartupAfterDelay;
    int32_t   __upsRebootWithDuration;
    int32_t   __upsAutoRestart;
} upsControl_t;

/*
 * C manager interface stubs for UPS-MIB::upsControl.
 */

extern int
ups_mib_mgr_get_upsControl(struct snmp_session *s, upsControl_t **upsControl);

/*
 * C agent interface stubs for UPS-MIB::upsControl.
 */

extern int
ups_mib_agt_read_upsControl(upsControl_t *upsControl);
extern int
ups_mib_agt_register_upsControl();

/*
 * C type definitions for UPS-MIB::upsConfig.
 */

typedef struct upsConfig {
    int32_t   *upsConfigInputVoltage;
    int32_t   *upsConfigInputFreq;
    int32_t   *upsConfigOutputVoltage;
    int32_t   *upsConfigOutputFreq;
    int32_t   *upsConfigOutputVA;
    int32_t   *upsConfigOutputPower;
    int32_t   *upsConfigLowBattTime;
    int32_t   *upsConfigAudibleStatus;
    int32_t   *upsConfigLowVoltageTransferPoint;
    int32_t   *upsConfigHighVoltageTransferPoint;
    void      *_clientData;		/* pointer to client data structure */

    /* private space to hold actual values */

    int32_t   __upsConfigInputVoltage;
    int32_t   __upsConfigInputFreq;
    int32_t   __upsConfigOutputVoltage;
    int32_t   __upsConfigOutputFreq;
    int32_t   __upsConfigOutputVA;
    int32_t   __upsConfigOutputPower;
    int32_t   __upsConfigLowBattTime;
    int32_t   __upsConfigAudibleStatus;
    int32_t   __upsConfigLowVoltageTransferPoint;
    int32_t   __upsConfigHighVoltageTransferPoint;
} upsConfig_t;

/*
 * C manager interface stubs for UPS-MIB::upsConfig.
 */

extern int
ups_mib_mgr_get_upsConfig(struct snmp_session *s, upsConfig_t **upsConfig);

/*
 * C agent interface stubs for UPS-MIB::upsConfig.
 */

extern int
ups_mib_agt_read_upsConfig(upsConfig_t *upsConfig);
extern int
ups_mib_agt_register_upsConfig();


typedef struct ups_mib {
    upsIdent_t	*upsIdent;
    upsBattery_t	*upsBattery;
    upsInput_t	*upsInput;
    upsInputEntry_t	*upsInputEntry;
    upsOutput_t	*upsOutput;
    upsOutputEntry_t	*upsOutputEntry;
    upsBypass_t	*upsBypass;
    upsBypassEntry_t	*upsBypassEntry;
    upsAlarm_t	*upsAlarm;
    upsAlarmEntry_t	*upsAlarmEntry;
    upsTest_t	*upsTest;
    upsControl_t	*upsControl;
    upsConfig_t	*upsConfig;
} ups_mib_t;

/*
 * Initialization function:
 */

void ups_mib_agt_init(void);

#endif /* _UPS_MIB_H_ */
