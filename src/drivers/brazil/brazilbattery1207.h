/*
 * brazilbattery.h
 *
 *  Created on: Jun 10, 2016
 *      Author: wagner
 */

#ifndef SRC_DRIVERS_BRAZIL_BRAZILBATTERY1207_H_
#define SRC_DRIVERS_BRAZIL_BRAZILBATTERY1207_H_

class BrazilBattery1207
{
public:
	BrazilBattery1207();
	virtual ~BrazilBattery1207();

	void setBatteryCount(double battery_1207_serie,double battery_1207_parallel);
	void setExpander(double ampers_per_hour_nominal);
	double getBatteryVoltageNom();

	double calcBatteryLoadC1(double act_power);
	double calcVoltageMax(double load);
	double calcVoltageMin(double load);
	double calcTimeLeft(double load, double voltage);
	double calcTimeLeftPeukert(double load);
	double calcLevel(double load, double voltage);

	static const double VOLTAGE_12V_REF = 12.0;
	static const double VOLTAGE_12V_C1_MIN = 10.4;
	static const double VOLTAGE_12V_C1_MAX = 12.2;
	static const double AMPER_HOUR_C1 = 5.2;
	static const double LOAD_MIN = 0.6;
	static const double LOAD_MAX = 5.0;
	static const double PEUKERT_POW = 1.54;
	static const double PEUKERT_MUL = 1.2;
	static const double TIMELEFT_POW = 1.58;
	static const double TIMELEFT_MUL = 1.2;

protected:
	double calcTimeLeftC1(double voltage);

	static const int COEF_C1_SIZE = 4;
	static const int COEF_VI_SIZE = 4;
	static const int COEF_VF_SIZE = 4;
	static const double COEF_C1[];
	static const double COEF_VI[];
	static const double COEF_VF[];

	double battery_1207_serie;
	double battery_1207_parallel;
	double battery_expander;
private:

};

#endif /* SRC_DRIVERS_BRAZIL_BRAZILBATTERY1207_H_ */