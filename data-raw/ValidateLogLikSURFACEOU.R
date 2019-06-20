library(diversitree)
library(MGPMMammals)
library(ape)

# Diversitree does not accept singleton nodes and polytomies.
treeMammals <- collapse.singles(MGPMMammals::tree)
treeMammals <- multi2di(treeMammals)

# Create an OU log-likelihood function for each mammal trait
likOU.lg_BodyMass <- make.ou(
  tree = treeMammals,
  states = MGPMMammals::values[1,],
  states.sd = MGPMMammals::SEs[1,])
likOU.lg_BodyMass

likOU.lg_BrainMass <- make.ou(
  tree = treeMammals,
  states = MGPMMammals::values[2,],
  states.sd = MGPMMammals::SEs[2,])
likOU.lg_BrainMass

# Fit ML-fit of the log-likelihood function.
# x.init specifies initial values for the parameters alpha and sigma
# Trying with different x.init values can lead to different estimates
# due to non-convex likelihood function shape, i.e. local optima.
fitOU.lg_BodyMass <- find.mle(likOU.lg_BodyMass, x.init = c(0.1, 0.01))
fitOU.lg_BrainMass <- find.mle(likOU.lg_BrainMass, x.init = c(0.1, 0.01))

# Inferred parameters (sigma^2):
fitOU.lg_BodyMass$par[1]
fitOU.lg_BrainMass$par[1]

# Inferred parameters (alpha):
fitOU.lg_BodyMass$par[2]
fitOU.lg_BrainMass$par[2]

# ML-values:
fitOU.lg_BodyMass$lnLik
fitOU.lg_BrainMass$lnLik

# The joint ML-value:
# We use the fact that log-likelihood of the two traits is the sum of
# the two log-likelihoods (independent traits). This value equals the
# log-likelihood of the models A, C, and SURFACEOU to the mammal data:
fitOU.lg_BodyMass$lnLik + fitOU.lg_BrainMass$lnLik
