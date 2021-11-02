import random
import gym
import numpy as np
from collections import deque
from keras.models import Sequential
from keras.layers import Dense
from tensorflow.keras.optimizers import Adam

from score_logger import ScoreLogger

ENV_NAME = "CartPole-v1"

GAMMA = 0.95
LEARNING_RATE = 0.001

MEMORY_SIZE = 1000000
BATCH_SIZE = 20

EXPLORATION_MAX = 1.0
EXPLORATION_MIN = 0.01
EXPLORATION_DECAY = 0.995

MAX_EPISODES = 1000

class DQNSolver:
    def __init__(self, observation_space, action_space):
        """
        initialize DQN manager object
        """
        self.exploration_rate = EXPLORATION_MAX

        self.action_space = action_space
        self.memory = deque(maxlen=MEMORY_SIZE)

        self.model = Sequential()
        self.model.add(Dense(24, input_shape=(observation_space,), activation="relu"))
        self.model.add(Dense(24, activation="relu"))
        self.model.add(Dense(self.action_space, activation="linear"))
        self.model.compile(loss="mse", optimizer=Adam(lr=LEARNING_RATE))

    def remember(self, state, action, reward, next_state, done):
        """
        append current enviornment state to memory
        """
        self.memory.append((state, action, reward, next_state, done))

    def act(self, state):
        """
        take action based on current observed state.

        state -> observed state of the enviornment
        """
        if np.random.rand() < self.exploration_rate:
            return random.randrange(self.action_space)
        q_values = self.model.predict(state)
        return np.argmax(q_values[0])

    def experience_replay(self):
        if len(self.memory) < BATCH_SIZE:
            return
        batch = random.sample(self.memory, BATCH_SIZE)
        for state, action, reward, state_next, terminal in batch:
            q_update = reward
            if not terminal:
                q_update = (reward + GAMMA * np.amax(self.model.predict(state_next)[0]))
            q_values = self.model.predict(state)
            q_values[0][action] = q_update
            self.model.fit(state, q_values, verbose=0)
        self.exploration_rate *= EXPLORATION_DECAY
        self.exploration_rate = max(EXPLORATION_MIN, self.exploration_rate)


def cartpole_training(render_training_image = False):
    """
    this function performs episodic training of the 
    cart-pole DQN model using the Open AI Gym enviornment.
    A copy of the model will be saved to "model/cartpole_model".

    params:
        render_training_image (bool): should the episode be visualized?
    returns:
        None
    """
    # set up enviornment for cart-pole
    env = gym.make(ENV_NAME)

    # set up score logging object
    score_logger = ScoreLogger(ENV_NAME)

    # set up observation and action space instnaces
    observation_space = env.observation_space.shape[0]
    action_space = env.action_space.n

    # set up DQN objects
    dqn_solver = DQNSolver(observation_space, action_space)
    run = 0

    # start episodic training
    while True:
        # save model once we've reached MAX_EPISODES
        if(run >= MAX_EPISODES):
            dqn_solver.model.save("model/cartpole_model")
            break

        # reset enviornment before episode start
        run += 1
        state = env.reset()
        state = np.reshape(state, [1, observation_space])
        step = 0

        # begin episode
        while True:
            step += 1

            # render training if flag was set
            if(render_training_image):
                env.render()

            # get action from current state using DQN model
            action = dqn_solver.act(state)

            # advance enviornment state by taking action
            state_next, reward, terminal, info = env.step(action)

            # modify reward as positive or negative depending on outcome of movement
            # (i.e. did we lose balance?)
            reward = reward if not terminal else -reward

            # get next state
            state_next = np.reshape(state_next, [1, observation_space])

            # append current state, action and reward to memory
            dqn_solver.remember(state, action, reward, state_next, terminal)

            # increment state
            state = state_next

            # if we have lose control, end the episode
            # and log data
            if terminal:
                print("Run: " + str(run) + ", exploration: " + str(dqn_solver.exploration_rate) + ", score: " + str(step))
                score_logger.add_score(step, run)
                break

            # perform replay process
            dqn_solver.experience_replay()

if __name__ == "__main__":
    cartpole_training()
