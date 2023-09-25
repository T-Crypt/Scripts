import pygame
import sys
import random

# Initialize pygame
pygame.init()

# Constants
WIDTH, HEIGHT = 400, 400
GRID_SIZE = 20
GRID_WIDTH = WIDTH // GRID_SIZE
GRID_HEIGHT = HEIGHT // GRID_SIZE
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
GREEN = (0, 255, 0)
RED = (255, 0, 0)

# Initialize the screen
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Snake Game")

# Initialize fonts
font = pygame.font.Font(None, 36)

# Initialize clock
clock = pygame.time.Clock()

# Initialize the snake and food
snake = [(GRID_WIDTH // 2, GRID_HEIGHT // 2)]
food = (random.randint(0, GRID_WIDTH - 1), random.randint(0, GRID_HEIGHT - 1))
dx, dy = 1, 0
score = 0

# Game loop
while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_UP and dy == 0:
                dx, dy = 0, -1
            elif event.key == pygame.K_DOWN and dy == 0:
                dx, dy = 0, 1
            elif event.key == pygame.K_LEFT and dx == 0:
                dx, dy = -1, 0
            elif event.key == pygame.K_RIGHT and dx == 0:
                dx, dy = 1, 0

    # Move the snake
    new_head = (snake[0][0] + dx, snake[0][1] + dy)
    snake.insert(0, new_head)

    # Check for collisions
    if snake[0] == food:
        score += 1
        food = (random.randint(0, GRID_WIDTH - 1), random.randint(0, GRID_HEIGHT - 1))
    else:
        snake.pop()

    # Check if the snake hits the wall or itself
    if (
        snake[0][0] < 0
        or snake[0][0] >= GRID_WIDTH
        or snake[0][1] < 0
        or snake[0][1] >= GRID_HEIGHT
        or snake[0] in snake[1:]
    ):
        pygame.quit()
        sys.exit()

    # Draw the screen
    screen.fill(BLACK)
    
    for segment in snake:
        pygame.draw.circle(screen, GREEN, (segment[0] * GRID_SIZE + GRID_SIZE // 2, segment[1] * GRID_SIZE + GRID_SIZE // 2), GRID_SIZE // 2)
    
    pygame.draw.circle(screen, RED, (food[0] * GRID_SIZE + GRID_SIZE // 2, food[1] * GRID_SIZE + GRID_SIZE // 2), GRID_SIZE // 2)

    # Display the score
    text = font.render(f"Score: {score}", True, WHITE)
    screen.blit(text, (10, 10))

    # Update the display
    pygame.display.update()

    # Cap the frame rate
    clock.tick(10)
