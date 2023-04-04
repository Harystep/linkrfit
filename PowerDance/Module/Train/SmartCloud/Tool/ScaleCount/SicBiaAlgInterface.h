/* ********************************************************************************
 * Copyright (C), 2019, SIC Tech. Co., Ltd.
 * File name: 阻抗法人体成分测量算法接口头文件
 * Author: aixinyu
 * Version: 1.0.0
 * Date: 2019.7.12
 * Description: 本算法主要用于测量人体成分，包括如下体脂、肌肉、骨盐量、水分、
 *				内脏脂肪、身体质量指数、基础代谢率、生理年龄等数据。
 * Modify Date: 2019.10.8
 * Version: 2.0.0
 * Author: aixinyu
 * Description: 合并源代码文件、添加运动员模式，体重、肌肉、脂肪控制，优化标准体重，优化身体评分，使用浮点型，输出两位小数精度
 * Modify Date: 2019.12.11
 * Version: 2.1.0
 * Author: aixinyu
 * Description: 修改运动员模式的BMI差距，修改身体评分，添加心率解密，添加阻抗范围可调节功能
**********************************************************************************/


#ifndef	SIC_BIA_ALG_INTERFACE_H
#define SIC_BIA_ALG_INTERFACE_H


#include <string.h>
#include <stdlib.h>

/* *****Bia算法报错类型******/
typedef enum
{
	SIC_BIA_NONE         = 0,  // 无报错
	SIC_BIA_POINTER_NULL = 1,  // 输入结构体指针为空
	SIC_BIA_AGE_L        = 2,  // 年龄过小
	SIC_BIA_AGE_H        = 3,  // 年龄过大
	SIC_BIA_HEIGHT_L     = 4,  // 身高过低
	SIC_BIA_HEIGHT_H     = 5,  // 身高过高
	SIC_BIA_WEIGHT_L     = 6,  // 体重过轻
	SIC_BIA_WEIGHT_H     = 7,  // 体重过重
	SIC_BIA_IMPEDANCE_L  = 8,  // 阻抗过小
	SIC_BIA_IMPEDANCE_H  = 9,  // 阻抗过大
	SIC_BIA_BMI_L        = 10, // BMI过低
	SIC_BIA_INPUTERR     = 11, // 输入错误
}SicBiaErrType;


/* *****  性别  ******/
typedef enum
{
	SIC_FEMALE           = 0,  // 普通女性
	SIC_MALE             = 1,  // 普通男性
	SIC_SPORTWOMAN       = 2,  // 女运动员
	SIC_SPORTMAN         = 3,  // 男运动员
}SicSexEnum;


/* *****阻抗法身体成分计算算法输出结构体******/
typedef struct
{
	//需要计算的参数
	unsigned short BMI;       // 身体质量指数（保留两位小数，即输出为实际数值的100倍）
	unsigned short BFR;       // 体脂率 %（保留两位小数，即输出为实际数值的10000倍）（0-10000）
	unsigned short LBM;       // 去脂体重 KG（保留两位小数，即输出为实际数值的100倍）（2000-18000）
	unsigned short BWR;       // 水分率 %（保留两位小数，即输出为实际数值的10000倍）（0-10000）
	unsigned short BMC;       // 骨含量（骨盐含量）KG（保留两位小数，即输出为实际数值的100倍）（2000-18000）
	unsigned short SLM;       // 肌肉含量 KG（保留两位小数，即输出为实际数值的100倍）（2000-18000）
	unsigned short SMC;       // 骨骼肌含量 KG（保留两位小数，即输出为实际数值的100倍）（2000-18000）
	unsigned short BPR;       // 蛋白质率 %（保留两位小数，即输出为实际数值的10000倍）（0-10000）
	unsigned short VFR;       // 内脏脂肪等级（保留两位小数，即输出为实际数值的100倍）
	unsigned short SBW;       // 标准体重 KG（保留两位小数，即输出为实际数值的100倍）（2000-18000）
	//unsigned short IBW;       // 理想体重 KG（保留两位小数，即输出为实际数值的100倍）（2000-18000）
	unsigned short BMR;       // 基础代谢率 Kcal/m*m（不放大）
	unsigned short BPM;       // 心率（保留两位小数，即输出为实际数值的100倍）
	//相关重量控制参数
	short          BOD;       // 肥胖度 %（保留两位小数，即输出为实际数值的10000倍）（-10000-32000）
	short          WTC;       // 体重控制 KG（保留两位小数，即输出为实际数值的100倍）（-16000~16000）
	short          FTC;       // 脂肪控制 KG（保留两位小数，即输出为实际数值的100倍）（-16000~16000）
	short          MTC;       // 肌肉控制 KG（保留两位小数，即输出为实际数值的100倍）（-16000~16000）
	//最后两个参数
	unsigned char PhyAge;     // 生理年龄
	unsigned char SCORE;      // 身体评分

	//根据计算结果判定等级
	unsigned char bfw_l;     // 身体体重评价等级
	unsigned char bod_l;     // 身体肥胖度评价等级
	unsigned char bmi_l;     // 身体BMI评价等级
	unsigned char bfr_l;     // 身体体脂率评价等级
	unsigned char bwr_l;     // 身体水分率评价等级
	unsigned char bmc_l;     // 身体骨含量（骨盐含量）评价等级
	unsigned char slm_l;     // 身体肌肉含量评价等级
	unsigned char smc_l;     // 身体骨骼肌评价等级
	unsigned char bpr_l;     // 身体蛋白质率评价等级
	unsigned char vfr_l;     // 身体内脏脂肪等级评价等级
	unsigned char bmr_l;     // 基础代谢率评价等级
	unsigned char BodyType;  // 体型评价

	//判定以上等级所用到的分界点
	unsigned short bfw_l_dp[6];     // 身体体重评价等级的分界点(保留两位小数，即100倍输出)
	short          bod_l_dp[8];     // 身体肥胖度评价等级的分界点(保留两位小数，即100倍输出)
	unsigned short bmi_l_dp[5];     // 身体BMI评价等级的分界点(保留两位小数，即100倍输出)
	unsigned short bfr_l_dp[5];     // 身体体脂率评价等级的分界点(保留两位小数，即10000倍输出)
	unsigned short bwr_l_dp[4];     // 身体水分率评价等级的分界点(保留两位小数，即10000倍输出)
	unsigned short bmc_l_dp[4];     // 身体骨含量（骨盐含量）评价等级的分界点(保留两位小数，即100倍输出)
	unsigned short slm_l_dp[4];     // 身体肌肉含量评价等级的分界点(保留两位小数，即100倍输出)
	unsigned short smc_l_dp[4];     // 身体骨骼肌含量评价等级的分界点(保留两位小数，即100倍输出)
	unsigned short bpr_l_dp[4];     // 身体蛋白质率评价等级的分界点(保留两位小数，即10000倍输出)
	unsigned short vfr_l_dp[5];     // 身体内脏脂肪等级评价等级的分界点(保留两位小数，即100倍输出)
	unsigned short bmr_l_dp[4];     // 基础代谢率评价等级的分界点（没有小数点，一倍输出）
}SicBiaAlgOutInfStr;


/* *****阻抗法身体成分分析算法输入结构体******/
typedef struct
{
	SicSexEnum     Sex;         // 性别: 0：普通女性；1、普通男性；2、女运动员；3、男运动员（默认屏蔽运动员模式）
	unsigned short Age;         // 年龄: 18 - 99    （输入为实际数值的10倍） （180-990）
	unsigned short Height;      // 身高: 90 - 226   （输入为实际数值的10倍） （900-2260）
	unsigned short Weight;      // 体重: 20 - 180 Kg（输入为实际数值的100倍）（2000-18000）
	unsigned short Impedance;   // 阻抗: 
	unsigned short HeartRate;   // 心率:
	unsigned char  Location;    // 定位: 0：国内；   非0：国际（国际推荐设置为1）（默认屏蔽国外）
}SicBiaAlgInInfStr;


/* *****静态变量声明******/
volatile static int SIC_IMPEDANCE_MIN;//默认电阻最小值
volatile static int SIC_IMPEDANCE_MAX;//默认电阻最大值

/* *****全局函数声明******/


/* *
* 身体成分计算
*/
extern SicBiaErrType SicBiaAlg(SicBiaAlgInInfStr* Person, SicBiaAlgOutInfStr* Body);


/* *
* 算法版本号
* 九位整数：
* 例：123456789，则版本号是123.456.789
*/
extern int SicGetBiaAlgVersion(void);



/* *
* 阻抗上下限设置
* 返回：0：设置成功
*      1：阻抗上限过大
*      2：阻抗上限过小
*      3：阻抗下限过大
*      4：阻抗下限过小
*/
extern short SicSetBiaAlgImpLimit(short MaxImpedance, short MinImpedance);


#endif


