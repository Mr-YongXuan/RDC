package cyou.wssy001.rdcspringbootdemo.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * @projectName: rdc-springboot-demo
 * @className: EventDto
 * @description: 聚合所有事件中所附带的key
 * @author: alexpetertyler
 * @date: 2021/4/12
 * @version: v1.0
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@ApiModel(description = "EventDto对象")
public class EventDto implements Serializable {
    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "起飞or着陆机场名称 (于航母或者其他地面上着陆统一显示为Wilde)", example = "Kutaisi")
    private String basename;

    @ApiModelProperty(value = "玩家游戏内呼号", example = "Zhangsan")
    private String callsign;

    @ApiModelProperty(value = "玩家阵营 0:观察者 1.红方 2.蓝方", example = "0")
    private Integer coalition;

    @ApiModelProperty(value = "事件名称", example = "takeoff")
    private String event;

    @ApiModelProperty(value = "是否为AI玩家", example = "true")
    private boolean isAi;

    @ApiModelProperty(value = "飞行员名称", example = "Zhangsan")
    private String pilotName;

    @ApiModelProperty(value = "玩家昵称", example = "A2A_Spawn_Init_NORM#001-02")
    private String playerName;

    @ApiModelProperty(value = "玩家载具名称", example = "Su-33")
    private String playerType;

    @ApiModelProperty(value = "玩家唯一识别符", example = "AKJH-DASD-KGAS")
    private String playerUcid;

    @ApiModelProperty(value = "游戏内时间戳", example = "63792.68")
    private Double time;

    @ApiModelProperty(value = "发射的武器名称", example = "AIM_120C")
    private String weaponName;

    @ApiModelProperty(value = "武器的类型, 详情可以参考DCS的枚举, 但该数据经过我多次测试发现几乎所有武器类型都为2, 所以这可能是不准确的", example = "2")
    private Integer weaponType;

    @ApiModelProperty(value = "目标玩家呼号", example = "Zhangsan")
    private String targetCallsign;

    @ApiModelProperty(value = "目标玩家阵营 0:观察者 1.红方 2.蓝方", example = "0")
    private Integer targetCoalition;

    @ApiModelProperty(value = "目标玩家是否为AI", example = "true")
    private Boolean targetIsAi;

    @ApiModelProperty(value = "目标玩家昵称", example = "Zhangsan")
    private String targetName;

    @ApiModelProperty(value = "目标玩家飞行员昵称", example = "A2A_Spawn_Init_NORM#001-02")
    private String targetPilotName;

    @ApiModelProperty(value = "目标玩家载具名称", example = "Su-33")
    private String targetType;

    @ApiModelProperty(value = "玩家制空时长", example = "0")
    private Double inairSecond;

    @ApiModelProperty(value = "玩家机型", example = "FA-18C_hornet")
    private String plane;

    @ApiModelProperty(value = "玩家在服务器游玩总时长", example = "241")
    private Double totalSecond;

    @ApiModelProperty(value = "玩家阵营 0:观察者 1.红方 2.蓝方", example = "0")
    private Integer playerSide;

    @ApiModelProperty(value = "受害者昵称", example = "Zhangsan")
    private String victimName;

    @ApiModelProperty(value = "受害者阵营 0:观察者 1.红方 2.蓝方", example = "0")
    private Integer victimSide;

    @ApiModelProperty(value = "受害者载具名称", example = "MiG-23MLD")
    private String victimType;

    @ApiModelProperty(value = "受害者唯一识别符", example = "QWUI-OELAK-JSLD-GASAD")
    private String victimUcid;

    @ApiModelProperty(value = "使用的武器", example = "FA-18C_hornet")
    private String weaponUsed;

    @ApiModelProperty(value = "玩家IP地址", example = "1.2.3.4:12631")
    private String playerIpaddr;

    @ApiModelProperty(value = "切换席位前选择的阵营 0:观众席 1:红方 2:蓝方", example = "1")
    private Integer prevSide;

    @ApiModelProperty(value = "当前席位id", example = "403")
    private String soltId;
}
