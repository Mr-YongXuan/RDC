package cyou.wssy001.rdcspringbootdemo.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum EventType {

    SHOT("shot"),
    HIT("hit"),
    TAKEOFF("takeoff"),
    LAND("land"),
    CRASH("crash"),
    EJECTION("eject"),
    REFUELING_START("refuelingStart"),
    DEAD("dead"),
    PILOT_DEAD("pilotDead"),
    REFUELING_STOP("refuelingStop"),
    BIRTH("birth"),
    DETAILED_FAILURE("detailedFailure"),
    PILOT_FAILURE("pilotFailure"),
    ENGINE_START_UP("engineStartup"),
    ENGINE_SHUT_DOWN("engineShutdown"),
    PLAYER_ENTER_UNIT("playerEnterUnit"),
    PLAYER_LEAVE_UNIT("playerLeaveUnit"),
    INAIR_TIME("inair_time"),
    GAME_TIME("game_time"),
    KILL("kill"),
    FRIENDLY_KILL("friendly_kill"),
    CONNECT("connect"),
    DISCONNECT("disconnect"),
    CHANGE_SLOT("change_slot");

    private final String name;

    public static EventType getTypeByName(String name) {
        for (EventType en : EventType.values()) {
            if (en.name.equals(name)) return en;
        }
        return null;
    }
}
