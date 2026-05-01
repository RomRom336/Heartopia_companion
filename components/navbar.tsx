'use client'

import Link from 'next/link'
import { useState } from 'react'
import { Heart, LogOut, Menu, Users, User as UserIcon, X } from 'lucide-react'
import { useAuth } from '@/components/auth-provider'
import { ThemeToggle } from '@/components/theme-toggle'
import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { cn } from '@/lib/utils'

const NAV_LINKS = [
  { href: '/tracker', label: 'Tracker' },
  { href: '/cuisine', label: 'Cuisine' },
  { href: '/chat',    label: 'Chat 🐱' },
]

export function Navbar() {
  const [mobileOpen, setMobileOpen] = useState(false)
  const { user, signOut } = useAuth()

  return (
    <header className="sticky top-0 z-40 w-full border-b border-border/60 bg-background/80 backdrop-blur">
      <div className="container flex h-16 items-center justify-between">
        <Link
          href="/"
          className="flex items-center gap-2 font-semibold tracking-tight"
          onClick={() => setMobileOpen(false)}
        >
          <Heart className="h-5 w-5 fill-primary text-primary" />
          <span>
            Heartopia <span className="text-primary">Companion</span>
          </span>
        </Link>

        {/* Liens desktop */}
        <nav className="hidden items-center gap-1 md:flex">
          {NAV_LINKS.map(link => (
            <Link
              key={link.href}
              href={link.href}
              className="rounded-md px-3 py-2 text-sm font-medium text-muted-foreground transition-colors hover:bg-accent/20 hover:text-foreground"
            >
              {link.label}
            </Link>
          ))}
        </nav>

        {/* Actions desktop */}
        <div className="hidden items-center gap-2 md:flex">
          <Link
            href="/friends"
            className="rounded-md p-1.5 text-muted-foreground transition-colors hover:bg-accent/20 hover:text-foreground"
            aria-label="Amis"
            title="Amis"
          >
            <Users className="h-5 w-5" />
          </Link>
          <ThemeToggle />
          {user ? (
            <UserMenu email={user.email ?? ''} onSignOut={signOut} />
          ) : (
            <AuthButtons />
          )}
        </div>

        {/* Toggle mobile */}
        <button
          onClick={() => setMobileOpen(v => !v)}
          className="inline-flex h-10 w-10 items-center justify-center rounded-md text-muted-foreground hover:bg-accent/20 md:hidden"
          aria-label="Ouvrir le menu"
          aria-expanded={mobileOpen}
        >
          {mobileOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
        </button>
      </div>

      {/* Drawer mobile */}
      <div
        className={cn(
          'overflow-hidden border-t border-border/60 bg-background transition-[max-height] duration-300 md:hidden',
          mobileOpen ? 'max-h-96' : 'max-h-0',
        )}
      >
        <nav className="container flex flex-col gap-1 py-4">
          {NAV_LINKS.map(link => (
            <Link
              key={link.href}
              href={link.href}
              onClick={() => setMobileOpen(false)}
              className="rounded-md px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-accent/20 hover:text-foreground"
            >
              {link.label}
            </Link>
          ))}
          <Link
            href="/friends"
            onClick={() => setMobileOpen(false)}
            className="rounded-md px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-accent/20 hover:text-foreground"
          >
            Amis
          </Link>

          <div className="mt-2 flex items-center justify-between border-t border-border/60 pt-4">
            <ThemeToggle />
            {user ? (
              <Button
                variant="outline"
                size="sm"
                onClick={() => {
                  signOut()
                  setMobileOpen(false)
                }}
              >
                <LogOut className="h-4 w-4" />
                Déconnexion
              </Button>
            ) : (
              <div className="flex gap-2">
                <Button
                  asChild
                  variant="ghost"
                  size="sm"
                  onClick={() => setMobileOpen(false)}
                >
                  <Link href="/login">Se connecter</Link>
                </Button>
                <Button asChild size="sm" onClick={() => setMobileOpen(false)}>
                  <Link href="/register">S&apos;inscrire</Link>
                </Button>
              </div>
            )}
          </div>
        </nav>
      </div>
    </header>
  )
}

function AuthButtons() {
  return (
    <>
      <Button asChild variant="ghost" size="sm">
        <Link href="/login">Se connecter</Link>
      </Button>
      <Button asChild size="sm">
        <Link href="/register">S&apos;inscrire</Link>
      </Button>
    </>
  )
}

function UserMenu({
  email,
  onSignOut,
}: {
  email: string
  onSignOut: () => void
}) {
  const initials = email.slice(0, 2).toUpperCase()
  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <button
          className="flex h-9 w-9 items-center justify-center rounded-full bg-primary text-xs font-semibold text-primary-foreground transition-opacity hover:opacity-90 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
          aria-label="Menu utilisateur"
        >
          {initials}
        </button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-56">
        <DropdownMenuLabel className="font-normal">
          <span className="block text-xs text-muted-foreground">
            Connecté comme
          </span>
          <span className="block truncate text-sm font-medium">{email}</span>
        </DropdownMenuLabel>
        <DropdownMenuSeparator />
        <DropdownMenuItem asChild>
          <Link href="/account" className="cursor-pointer">
            <UserIcon className="mr-2 h-4 w-4" />
            Mon profil
          </Link>
        </DropdownMenuItem>
        <DropdownMenuItem
          onClick={onSignOut}
          className="cursor-pointer text-destructive focus:text-destructive"
        >
          <LogOut className="mr-2 h-4 w-4" />
          Déconnexion
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
