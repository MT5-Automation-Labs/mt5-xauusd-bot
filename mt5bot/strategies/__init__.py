"""Technical strategies that turn OHLC bars into buy and sell signals."""

from .aggressive_scalp import AggressiveScalpStrategy
from .base_strategy import BaseStrategy
from .bollinger_scalp import BollingerScalpStrategy
from .ema_crossover import EMACrossoverStrategy
from .hft_ema_scalper import HFTEMAScalper
from .macd_signal_cross import MACDSignalCrossStrategy
from .mean_reversion import MeanReversionStrategy
from .momentum_breakout import MomentumBreakoutStrategy
from .rsi_divergence import RSIDivergenceStrategy
from .stochastic_momentum import StochasticMomentumStrategy

__all__ = [
    "AggressiveScalpStrategy",
    "BaseStrategy",
    "BollingerScalpStrategy",
    "EMACrossoverStrategy",
    "HFTEMAScalper",
    "MACDSignalCrossStrategy",
    "MeanReversionStrategy",
    "MomentumBreakoutStrategy",
    "RSIDivergenceStrategy",
    "StochasticMomentumStrategy",
]
