package cyou.wssy001.rdcspringbootdemo.entity;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

/**
 * @projectName: rdc-springboot-demo
 * @className: HitEvent
 * @description: 命中事件
 * @author: alexpetertyler
 * @date: 2021/4/13
 * @version: v1.0
 */
@Setter
@Getter
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(description = "命中事件")
public class HitEvent extends BaseEvent implements Serializable {
    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "玩家游戏内呼号", example = "Zhangsan")
    private String callsign;

    @ApiModelProperty(value = "玩家阵营 0:观察者 1.红方 2.蓝方", example = "0")
    private Integer coalition;

    @ApiModelProperty(value = "是否为AI玩家", example = "true")
    private boolean isAi;

    @ApiModelProperty(value = "飞行员名称", example = "Zhangsan")
    private String pilotName;

    @ApiModelProperty(value = "玩家载具名称", example = "Su-33")
    private String playerType;

    @ApiModelProperty(value = "游戏内时间戳", example = "63792.68")
    private Double time;

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

    @ApiModelProperty(value = "发射的武器名称", example = "AIM_120C")
    private String weaponName;

    @ApiModelProperty(value = "武器的类型, 详情可以参考DCS的枚举, 但该数据经过我多次测试发现几乎所有武器类型都为2, 所以这可能是不准确的", example = "2")
    private Integer weaponType;

    public HitEvent() {
        super(EventType.HIT, null, null);

    }

    public HitEvent(String playerName, String playerUcid, String callsign, Integer coalition, boolean isAi, String pilotName, String playerType, Double time, String targetCallsign, Integer targetCoalition, Boolean targetIsAi, String targetName, String targetPilotName, String targetType, String weaponName, Integer weaponType) {
        super(EventType.HIT, playerName, playerUcid);
        this.callsign = callsign;
        this.coalition = coalition;
        this.isAi = isAi;
        this.pilotName = pilotName;
        this.playerType = playerType;
        this.time = time;
        this.targetCallsign = targetCallsign;
        this.targetCoalition = targetCoalition;
        this.targetIsAi = targetIsAi;
        this.targetName = targetName;
        this.targetPilotName = targetPilotName;
        this.targetType = targetType;
        this.weaponName = weaponName;
        this.weaponType = weaponType;
    }
}
