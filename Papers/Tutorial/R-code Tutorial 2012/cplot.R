# modified version of centipede plot function to change axis size #(cex.axis1 argument)
# (adapted from centipede.plot function of plotrix package)
centipedePlot<-function (segs, mct = "mean", lower.limit = "std.error", upper.limit = lower.limit, 
    left.labels = NULL, right.labels = NULL, sort.segs = TRUE, 
    main = "", xlab = NA, pch = 21, vgrid = NA, hgrid = NA, gridcol = "lightgray", 
    mar = NA, col = par("fg"), bg = "green", cex.axis1=1.5,...) 
{
    if (missing(segs)) {
        cat("Usage: centipede.plot(segs,...)\n\twhere segs is a dstat object")
        stop("or a matrix of midpoints and limits")
    }
    if (is.list(segs)) {
        if (all(lapply(segs, is.numeric))) 
            segs <- get.segs(segs, mct = mct, lower.limit = lower.limit, 
                upper.limit = upper.limit)
        else stop("If segs is a list, all the components must be numeric")
    }
    if (class(segs) == "dstat") {
        midpoint <- "mean"
        if (lower.limit == "var") {
            if (rownames(segs)[2] == "var") 
                ll <- segs[1, ] - segs[2, ]
            if (rownames(segs)[2] == "sd") 
                ll <- segs[1, ] - segs[2, ] * segs[2, ]
        }
        if (upper.limit == "var") {
            if (rownames(segs)[2] == "var") 
                ul <- segs[1, ] + segs[2, ]
            if (rownames(segs)[2] == "sd") 
                ul <- segs[1, ] + segs[2, ] * segs[2, ]
        }
        if (lower.limit == "sd") {
            if (rownames(segs)[2] == "var") 
                ll <- segs[1, ] - sqrt(segs[2, ])
            if (rownames(segs)[2] == "sd") 
                ll <- segs[1, ] - segs[2, ]
        }
        if (upper.limit == "sd") {
            if (rownames(segs)[2] == "var") 
                ul <- segs[1, ] + sqrt(segs[2, ])
            if (rownames(segs)[2] == "sd") 
                ul <- segs[1, ] + segs[2, ]
        }
        if (lower.limit == "std.error") {
            if (rownames(segs)[2] == "var") 
                ll <- segs[1, ] - sqrt(segs[2, ])/sqrt(segs[3, 
                  ])
            if (rownames(segs)[2] == "sd") 
                ll <- segs[1, ] - segs[2, ]/sqrt(segs[3, ])
        }
        if (upper.limit == "std.error") {
            if (rownames(segs)[2] == "var") 
                ul <- segs[1, ] + sqrt(segs[2, ])/sqrt(segs[3, 
                  ])
            if (rownames(segs)[2] == "sd") 
                ul <- segs[1, ] + segs[2, ]/sqrt(segs[3, ])
        }
        segs <- rbind(segs[1, ], ll, ul, segs[3, ])
    }
    segdim <- dim(segs)
    if (sort.segs) {
        seg.order <- order(segs[1, ])
        segs <- segs[, seg.order]
    }
    else seg.order <- 1:segdim[2]
    oldpar <- par("mar")
    if (is.na(mar[1])) 
        mar <- c(4, 6, 1 + 2 * (nchar(main) > 0), 5)
    par(mar = mar)
    plot(x = c(min(segs[2, ]), max(segs[3, ])), y = c(1, segdim[2]), 
        main = main, xlab = "", ylab = "", type = "n", axes = FALSE, 
        ...)
    box()
    if (!is.na(vgrid[1])) 
        abline(v = vgrid, lty = 1, col = gridcol)
    if (is.null(hgrid)) 
        abline(h = 1:segdim[2], lty = 2, col = gridcol)
    else if (!is.na(hgrid[1])) 
        abline(h = hgrid, lty = 2, col = gridcol)
    axis(1,cex.axis=cex.axis1)
    arrows(segs[2, ], 1:segdim[2], segs[3, ], 1:segdim[2], length = 0.05, 
        angle = 90, code = 3, col = col)
    points(segs[1, ], 1:segdim[2], pch = pch, col = col, bg = bg)
    if (is.null(left.labels)) {
        left.labels <- colnames(segs)
        if (is.null(left.labels)) 
            left.labels <- paste("V", seg.order, sep = "")
    }
    else left.labels <- left.labels[seg.order]
    plot.limits <- par("usr")
    mtext(left.labels, 2, line = 0.2, at = 1:segdim[2], adj = 1, 
        las = 1)
    if (is.null(right.labels)) 
        right.labels <- paste(round(segs[1, ], 2), "(", segs[4, 
            ], ")", sep = "")
    else right.labels <- right.labels[seg.order]
    mtext(right.labels, 4, line = 0.2, at = 1:segdim[2], adj = 0, 
        las = 1)
    if (is.na(xlab)) 
        xlab <- paste("| -", rownames(segs)[2], "-", rownames(segs)[1], 
            "-", rownames(segs)[3], "- |")
    if (nchar(xlab)) 
        mtext(xlab, 1, line = 2)
    par(oldpar)
    invisible(segs)
}
