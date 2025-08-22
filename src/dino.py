import pygame
import random

# Initialize Pygame
pygame.init()

# Screen dimensions
WIDTH, HEIGHT = 800, 400
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Dinosaur Game")

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)

# Dinosaur settings
dino_width, dino_height = 40, 60
dino_x = 50
dino_y = HEIGHT - dino_height - 50
dino_vel_y = 0
gravity = 1
jump_power = 15
is_jumping = False

# Obstacle settings
obstacle_width, obstacle_height = 20, 40
obstacle_speed = 7
obstacle_list = []
spawn_timer = 0

# Score
score = 0
font = pygame.font.SysFont(None, 36)

clock = pygame.time.Clock()

def draw_dino(x, y):
    pygame.draw.rect(screen, BLACK, (x, y, dino_width, dino_height))

def draw_obstacle(obs):
    pygame.draw.rect(screen, BLACK, obs)

def show_score(score):
    text = font.render(f"Score: {score}", True, BLACK)
    screen.blit(text, (10, 10))

def main():
    global dino_y, dino_vel_y, is_jumping, score, spawn_timer

    run = True
    while run:
        clock.tick(30)
        screen.fill(WHITE)

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                run = False

        # Key press for jump
        keys = pygame.key.get_pressed()
        if keys[pygame.K_SPACE] and not is_jumping:
            dino_vel_y = -jump_power
            is_jumping = True

        # Dinosaur gravity and jump update
        dino_y += dino_vel_y
        dino_vel_y += gravity

        if dino_y >= HEIGHT - dino_height - 50:
            dino_y = HEIGHT - dino_height - 50
            is_jumping = False

        draw_dino(dino_x, dino_y)

        # Spawn obstacle
        spawn_timer += 1
        if spawn_timer > 60:
            obstacle_x = WIDTH
            obstacle_y = HEIGHT - obstacle_height - 50
            obstacle_list.append(pygame.Rect(obstacle_x, obstacle_y, obstacle_width, obstacle_height))
            spawn_timer = 0

        # Move obstacles
        for obs in list(obstacle_list):
            obs.x -= obstacle_speed
            draw_obstacle(obs)
            if obs.x + obstacle_width < 0:
                obstacle_list.remove(obs)
                score += 1

            # Collision detection
            dino_rect = pygame.Rect(dino_x, dino_y, dino_width, dino_height)
            if dino_rect.colliderect(obs):
                run = False  # Game over

        show_score(score)

        pygame.display.flip()

    pygame.quit()

if __name__ == "__main__":
    main()
