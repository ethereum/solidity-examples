import * as chalk from "chalk";
import {println} from "./io";

export default class TestLogger {

    private static __silent = false;

    public static header(text: string) {
        println(chalk["cyanBright"](text));
    }

    public static info(text: string) {
        if (!TestLogger.__silent) {
            println(chalk["blueBright"](text));
        }
    }

    public static success(text: string) {
        if (!TestLogger.__silent) {
            println(chalk["greenBright"](text));
        }
    }

    public static moderate(text: string) {
        if (!TestLogger.__silent) {
            println(chalk["yellowBright"](text));
        }
    }

    public static fail(text: string) {
        println(chalk["redBright"](text));
    }

    public static setSilent(silent: boolean) {
        TestLogger.__silent = silent;
    }

    public static silent(): boolean {
        return TestLogger.__silent;
    }

}
