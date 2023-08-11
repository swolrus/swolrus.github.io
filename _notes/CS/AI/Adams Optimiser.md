---
title: Adam's Optimiser
latex: true
---



This is done at each neuron
Additionally should be done also for the weight at the neuron

$$initialise: m_0 \leftarrow 0, V_0 \leftarrow, t \leftarrow 0$$

$$m_t = \beta_1 m_{t-1} + (1 -\beta_1 ) \dot g_t$$
$$V_t = \beta_2 V_{t-1} + (1 -\beta_2 ) g_t^2$$

Bias Reduction of initialisation $$m$$, $$v$$ to zero:
$$\hat m_t = \frac{m_t}{(1-\beta_1^t)}$$
$$\hat V_t = \frac{v_t}{(1-\beta_2^t)}$$


$$\theta _t = \theta _{t-1} - \gamma \frac{\hat m_t}{\sqrt{\hat V_t} + \epsilon}$$
