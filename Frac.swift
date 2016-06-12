/*
 **
 ** find rational approximation to given real number
 ** Port to Swift by Anthony Orlando Destro, June 12, 2016
 ** David Eppstein / UC Irvine / 8 Aug 1993
 **
 ** With corrections from Arno Formella, May 2008
 **
 ** usage: a.out r d
 **   r is real number to approx
 **   d is the maximum denominator allowed
 **
 ** based on the theory of continued fractions
 ** if x = a1 + 1/(a2 + 1/(a3 + 1/(a4 + ...)))
 ** then best approximation is found by truncating this series
 ** (with some adjustments in the last term).
 **
 ** Note the fraction can be recovered as the first column of the matrix
 **  ( a1 1 ) ( a2 1 ) ( a3 1 ) ...
 **  ( 1  0 ) ( 1  0 ) ( 1  0 )
 ** Instead of keeping the sequence of continued fraction terms,
 ** we just keep the last partial product of these matrices.
 */

func formatDoubleToFraction(startx: Double, maxden: Int) -> (String, String, Double, Double) {

    var x : Double = startx
    var ai: Int
    var m :[[Int]] = [[1,0],[0,1]]

    /* loop finding terms until denom gets too big */
    ai = Int(x)
    while (m[1][0] * ai + m[1][1] <= maxden) {
        var t: Int
        t = m[0][0] * ai + m[0][1]
        m[0][1] = m[0][0]
        m[0][0] = t
        t = m[1][0] * ai + m[1][1]
        m[1][1] = m[1][0]
        m[1][0] = t
        if (x == Double(ai)) {
            break
        }     // AF: division by zero
        x = 1 / (x - Double(ai))
        if (x > 0x7FFFFFFF) {
            break
        }  // AF: representation failure
        ai = Int(x)
    }

    /* now remaining x is between 0 and 1/ai */
    /* approx as either 0 or 1/m where m is max that will fit in maxden */
    /* first try zero */

    var first = "\(m[0][0]) / \(m[1][0])"
    var firsterror = startx - (Double(m[0][0])  / Double(m[1][0]))

    /* now try other possibility */
    ai = (maxden - m[1][1]) / m[1][0];
    m[0][0] = m[0][0] * ai + m[0][1];
    m[1][0] = m[1][0] * ai + m[1][1];

    var second = "\(m[0][0]) / \(m[1][0])"
    var seconderror = startx - (Double(m[0][0])  / Double(m[1][0]))

    return (first, second, firsterror, seconderror)
}