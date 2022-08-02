namespace Flixball/Terminal {

    def escape(s: String): String =
        "\u001B${s}"

    def csi(s: String): String =
        escape("[${s}")

    ///
    /// Upper left corner is coordinate `x=0`, `y=0`.
    ///
    pub def setCursor(x: {x::Int32}, y: Int32): String = csi("${y+1};${x.x+1}H")

    ///
    /// Clears the terminal screen without changing the cursor position.
    ///
    pub def clearScreen(): String = csi("2J")

    ///
    /// Clears the screen and moves the cursor to the top left position.
    /// Equivalen to `clearScreen` and then `setCursor(x = 0, 0)`.
    ///
    pub def resetTerminal(): String =
        clearScreen() + setCursor(x = 0, 0)

}
