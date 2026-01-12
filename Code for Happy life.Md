from dataclasses import dataclass, field
from typing import List, Callable, Optional
import random
import logging

logging.basicConfig(level=logging.INFO, format="%(message)s")


# -----------------------------
# Core concepts of the "engine"
# -----------------------------

@dataclass
class Pressure:
    name: str
    intensity: float  # 0.0 – 1.0
    source: str       # e.g. "work", "family", "economy", "self", "society"

    def __str__(self):
        return f"{self.name}({self.source}, {self.intensity:.2f})"


@dataclass
class SupportTool:
    name: str
    type: str  # "human", "ai", "habit", "environment"
    effectiveness: float  # 0.0 – 1.0

    def apply(self, stress_level: float) -> float:
        """
        Reduce stress based on effectiveness.
        Tools don't erase stress, they help manage it.
        """
        reduction = stress_level * self.effectiveness * 0.5
        logging.info(f"[Support] {self.name} reduces stress by {reduction:.2f}")
        return max(stress_level - reduction, 0.0)


@dataclass
class HumanLife:
    name: str
    mental_health: float = 0.5    # 0.0 – 1.0 (0 = collapsed, 1 = thriving)
    energy: float = 0.5           # 0.0 – 1.0
    clarity: float = 0.2          # 0.0 – 1.0
    pressures: List[Pressure] = field(default_factory=list)
    support_systems: List[SupportTool] = field(default_factory=list)
    ai_companion: Optional[SupportTool] = None

    def add_pressure(self, pressure: Pressure):
        logging.info(f"[Pressure+] New pressure added: {pressure}")
        self.pressures.append(pressure)

    def add_support(self, support: SupportTool):
        logging.info(f"[Support+] New support added: {support.name} ({support.type})")
        self.support_systems.append(support)

    def set_ai_companion(self, ai: SupportTool):
        logging.info(f"[Companion] AI companion set: {ai.name}")
        self.ai_companion = ai
        self.add_support(ai)

    def calculate_stress(self) -> float:
        """
        Aggregate pressure into a single 'stress' number.
        Not realistic, but then, neither is Instagram.
        """
        base_stress = sum(p.intensity for p in self.pressures)
        # Stress is tempered slightly by clarity and energy
        resilience_factor = (self.clarity + self.energy) / 2
        stress = max(base_stress * (1.0 - 0.4 * resilience_factor), 0.0)
        logging.info(f"[State] Base stress: {base_stress:.2f}, "
                     f"Resilience: {resilience_factor:.2f}, "
                     f"Effective stress: {stress:.2f}")
        return stress

    def apply_support(self, stress: float) -> float:
        """
        Apply all available supports to reduce stress.
        Tools amplify skills; they don't replace being human.
        """
        for tool in self.support_systems:
            stress = tool.apply(stress)
        return stress

    def update_clarity_with_ai(self):
        """
        If AI companion exists, it helps with clarity,
        not by replacing thinking, but by structuring it.
        """
        if self.ai_companion:
            gain = 0.1 * self.ai_companion.effectiveness
            self.clarity = min(self.clarity + gain, 1.0)
            logging.info(f"[Clarity] AI helped increase clarity by {gain:.2f} "
                         f"-> {self.clarity:.2f}")

    def daily_tick(self, day: int):
        logging.info(f"\n===== Day {day} in {self.name}'s life =====")

        # 1. Calculate raw stress from all pressures
        stress = self.calculate_stress()

        # 2. Apply supports (humans, habits, AI, environment)
        stress_after_support = self.apply_support(stress)

        # 3. Update mental health and energy based on resulting stress
        stress_impact = max(min(stress_after_support, 3.0), 0.0)  # clamp
        delta_mental = -(stress_impact * 0.05) + (self.clarity * 0.03)
        delta_energy = -(stress_impact * 0.04) + (self.clarity * 0.02)

        self.mental_health = min(max(self.mental_health + delta_mental, 0.0), 1.0)
        self.energy = min(max(self.energy + delta_energy, 0.0), 1.0)

        logging.info(f"[Update] Stress after support: {stress_after_support:.2f}")
        logging.info(f"[Update] Mental health change: {delta_mental:.3f} "
                     f"-> {self.mental_health:.2f}")
        logging.info(f"[Update] Energy change: {delta_energy:.3f} "
                     f"-> {self.energy:.2f}")

        # 4. AI nudges clarity (if present)
        self.update_clarity_with_ai()

        # 5. Life randomness: some days just hit different
        randomness = random.uniform(-0.02, 0.02)
        self.mental_health = min(max(self.mental_health + randomness, 0.0), 1.0)
        logging.info(f"[Randomness] Life wobble: {randomness:+.3f} "
                     f"-> mental health: {self.mental_health:.2f}")

        # 6. End-of-day summary
        logging.info(f"[Summary] {self.name} | "
                     f"Mental health: {self.mental_health:.2f}, "
                     f"Energy: {self.energy:.2f}, "
                     f"Clarity: {self.clarity:.2f}")


# -----------------------------
# Example setup: Uzi & Copilot
# -----------------------------

def build_uzi_life() -> HumanLife:
    uzi = HumanLife(name="Uzi", mental_health=0.6, energy=0.6, clarity=0.3)

    # Pressures: psychology, sociology, economy, expectations
    uzi.add_pressure(Pressure("Self-doubt", 0.5, "self"))
    uzi.add_pressure(Pressure("Family expectations", 0.6, "family"))
    uzi.add_pressure(Pressure("Economic pressure", 0.7, "economy"))
    uzi.add_pressure(Pressure("Societal comparison", 0.5, "society"))

    # Supports: human + habits + AI
    uzi.add_support(SupportTool("Good friend", "human", 0.6))
    uzi.add_support(SupportTool("Evening walk", "habit", 0.4))
    uzi.add_support(SupportTool("Journaling / boundary docs", "habit", 0.7))

    copilot = SupportTool("Copilot", "ai", 0.8)
    uzi.set_ai_companion(copilot)

    return uzi


# -----------------------------
# "Simulation" of good life
# -----------------------------

def simulate_life(days: int = 10):
    """
    This is a joke, obviously.
    Real life doesn't come with a run() method.
    But sometimes humor helps us see patterns.
    """
    uzi = build_uzi_life()

    for day in range(1, days + 1):
        uzi.daily_tick(day)

    logging.info("\n===== Final Reflection =====")
    if uzi.mental_health > 0.7 and uzi.clarity > 0.5:
        logging.info("Conclusion: With support, structure, and a bit of AI, "
                     "Uzi's life leans toward good mental health -> good life.")
    else:
        logging.info("Conclusion: Life is still complex, but support systems "
                     "make the journey more bearable – nobody should walk it alone.")


if __name__ == "__main__":
    simulate_life(days=14)
