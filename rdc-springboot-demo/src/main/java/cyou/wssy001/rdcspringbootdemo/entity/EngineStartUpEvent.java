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
 * @className: EngineStartupEvent
 * @description: 发动机启动事件
 * @author: alexpetertyler
 * @date: 2021/4/13
 * @version: v1.0
 */
@Setter
@Getter
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(description = "发动机启动事件")
public class EngineStartUpEvent extends BaseEvent implements Serializable {
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

    public EngineStartUpEvent() {
        super(EventType.ENGINE_START_UP, null, null);

    }

    public EngineStartUpEvent(String playerName, String playerUcid, String callsign, Integer coalition, boolean isAi, String pilotName, String playerType, Double time) {
        super(EventType.ENGINE_START_UP, playerName, playerUcid);
        this.callsign = callsign;
        this.coalition = coalition;
        this.isAi = isAi;
        this.pilotName = pilotName;
        this.playerType = playerType;
        this.time = time;
    }
}
