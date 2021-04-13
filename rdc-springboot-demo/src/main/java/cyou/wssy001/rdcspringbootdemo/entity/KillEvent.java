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
 * @className: KillEvent
 * @description: 击杀事件
 * @author: alexpetertyler
 * @date: 2021/4/12
 * @version: v1.0
 */
@Setter
@Getter
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(description = "击杀事件")
public class KillEvent extends BaseEvent implements Serializable {
    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "玩家载具名称", example = "Su-33")
    private String playerType;

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

    public KillEvent() {
        super(EventType.KILL, null, null);
    }

    public KillEvent(String playerName, String playerUcid, String playerType, Integer playerSide, String victimName, Integer victimSide, String victimType, String victimUcid, String weaponUsed) {
        super(EventType.KILL, playerName, playerUcid);
        this.playerType = playerType;
        this.playerSide = playerSide;
        this.victimName = victimName;
        this.victimSide = victimSide;
        this.victimType = victimType;
        this.victimUcid = victimUcid;
        this.weaponUsed = weaponUsed;
    }
}
