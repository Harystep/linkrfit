//
//  CFFTypeDefineEnum.h
//  CofoFit
//
//  Created by PC-N121 on 2021/5/11.
//

#ifndef CFFTypeDefineEnum_h
#define CFFTypeDefineEnum_h

struct CFFTime {
    NSInteger hour;
    NSInteger minute;
};
typedef struct CG_BOXABLE CFFTime CFFTime;

CG_INLINE CFFTime
CFFTimeMake(NSUInteger hour, NSUInteger minute)
{
    CFFTime time; time.hour = hour; time.minute = minute; return time;
}



typedef NS_ENUM(NSUInteger, CFFGender) {
    CFFGender_Male   = 0,
    CFFGender_Female = 1 << 1
};

typedef NS_ENUM(NSUInteger, CFFEnergyInAndOutType) {
    CFFEnergyInAndOutType_In = 0,
    CFFEnergyInAndOutType_Out = 1,
};



#endif
